package global

import (
	"encoding/json"

	"github.com/butlergroup/caddy-ingress/pkg/converter"
	"github.com/butlergroup/caddy-ingress/pkg/store"
	caddy2 "github.com/caddyserver/caddy/v2"
	"github.com/caddyserver/caddy/v2/caddyconfig"
	"github.com/caddyserver/caddy/v2/modules/caddytls"
	"github.com/mholt/acmez/v3/acme"
)

type ConfigMapPlugin struct{}

func init() {
	converter.RegisterPlugin(ConfigMapPlugin{})
}

func (p ConfigMapPlugin) IngressPlugin() converter.PluginInfo {
	return converter.PluginInfo{
		Name: "configmap",
		New:  func() converter.Plugin { return new(ConfigMapPlugin) },
	}
}

func (p ConfigMapPlugin) GlobalHandler(config *converter.Config, store *store.Store) error {
	cfgMap := store.ConfigMap
	tlsApp := config.GetTLSApp()
	httpServer := config.GetHTTPServer()
	if cfgMap.Debug {
		config.Logging.Logs = map[string]*caddy2.CustomLog{"default": {BaseLog: caddy2.BaseLog{Level: "DEBUG"}}}
	}
	if cfgMap.AcmeCA != "" || cfgMap.Email != "" {
		acmeIssuer := caddytls.ACMEIssuer{}
		if cfgMap.AcmeCA != "" {
			acmeIssuer.CA = cfgMap.AcmeCA
		}
		if cfgMap.AcmeEABKeyID != "" && cfgMap.AcmeEABMacKey != "" {
			acmeIssuer.ExternalAccount = &acme.EAB{
				KeyID:  cfgMap.AcmeEABKeyID,
				MACKey: cfgMap.AcmeEABMacKey,
			}
		}
		if cfgMap.Email != "" {
			acmeIssuer.Email = cfgMap.Email
		}
		// NEW: DNS challenge configuration
		if cfgMap.AcmeDNSProvider != "" {
			providerRaw := caddyconfig.JSONModuleObject(
				map[string]interface{}{
					"api_token": "{env.CF_API_TOKEN}",
				},
				"name",
				cfgMap.AcmeDNSProvider,
				nil,
			)
			dnsConfig := &caddytls.DNSChallengeConfig{
				ProviderRaw: providerRaw,
			}
			var resolvers []string
			if err := json.Unmarshal([]byte(cfgMap.AcmeDNSResolvers), &resolvers); err == nil {
				dnsConfig.Resolvers = resolvers
			}
			if acmeIssuer.Challenges == nil {
				acmeIssuer.Challenges = &caddytls.ChallengesConfig{}
			}
			acmeIssuer.Challenges.DNS = dnsConfig
		}
		var onDemandConfig *caddytls.OnDemandConfig
		if cfgMap.OnDemandTLS {
			permissionRaw := caddyconfig.JSONModuleObject(
				map[string]interface{}{
					"endpoint": cfgMap.PermissionEndpoint,
				},
				"module",
				"http",
				nil,
			)
			onDemandConfig = &caddytls.OnDemandConfig{
				PermissionRaw: permissionRaw,
			}
		}
		tlsApp.Automation = &caddytls.AutomationConfig{
			OnDemand:          onDemandConfig,
			OCSPCheckInterval: cfgMap.OCSPCheckInterval,
			Policies: []*caddytls.AutomationPolicy{
				{
					IssuersRaw: []json.RawMessage{
						caddyconfig.JSONModuleObject(acmeIssuer, "module", "acme", nil),
					},
					OnDemand: cfgMap.OnDemandTLS,
				},
			},
		}
	}
	if cfgMap.ProxyProtocol {
		httpServer.ListenerWrappersRaw = []json.RawMessage{
			json.RawMessage(`{"wrapper":"proxy_protocol"}`),
			json.RawMessage(`{"wrapper":"tls"}`),
		}
	}
	return nil
}

// Interface guards
var (
	_ = converter.GlobalMiddleware(ConfigMapPlugin{})
)
