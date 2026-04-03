package caddy

import (
	"github.com/butlergroup/caddy-ingress/pkg/converter"
	"github.com/butlergroup/caddy-ingress/pkg/store"

	// Load default plugins
	_ "github.com/butlergroup/caddy-ingress/internal/caddy/global"
	_ "github.com/butlergroup/caddy-ingress/internal/caddy/ingress"
)

type Converter struct{}

func (c Converter) ConvertToCaddyConfig(store *store.Store) (any, error) {
	cfg := converter.NewConfig()

	for _, p := range converter.Plugins(store.Options.PluginsOrder) {
		if m, ok := p.(converter.GlobalMiddleware); ok {
			err := m.GlobalHandler(cfg, store)
			if err != nil {
				return cfg, err
			}
		}
	}
	return cfg, nil
}
