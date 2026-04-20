[![](https://img.shields.io/badge/license-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![CodeQL](https://github.com/butlergroup/caddy-ingress/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/butlergroup/caddy-ingress/actions/workflows/github-code-scanning/codeql)
[![Go CI](https://github.com/butlergroup/caddy-ingress/actions/workflows/main.yml/badge.svg)](https://github.com/butlergroup/caddy-ingress/actions/workflows/main.yml)
[![Dependabot Updates](https://github.com/butlergroup/caddy-ingress/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/butlergroup/caddy-ingress/actions/workflows/dependabot/dependabot-updates)
[![Go Report Card](https://goreportcard.com/badge/github.com/butlergroup/caddy-ingress)](https://goreportcard.com/report/github.com/butlergroup/caddy-ingress)
[![OSV-Scanner](https://github.com/butlergroup/caddy-ingress/actions/workflows/osv-scanner.yml/badge.svg)](https://github.com/butlergroup/caddy-ingress/actions/workflows/osv-scanner.yml)
[![Snyk Security-Monitored](https://img.shields.io/badge/Snyk%20Security-Monitored-purple)](https://app.snyk.io/share/784f6fef-6aaf-47ed-81ba-99e05b854665)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/12136/badge)](https://www.bestpractices.dev/projects/12136)
[![Scorecard supply-chain security](https://github.com/butlergroup/caddy-ingress/actions/workflows/scorecard.yml/badge.svg)](https://github.com/butlergroup/caddy-ingress/actions/workflows/scorecard.yml)
[![Microsoft Defender For Devops](https://github.com/butlergroup/caddy-ingress/actions/workflows/defender-for-devops.yml/badge.svg)](https://github.com/butlergroup/caddy-ingress/actions/workflows/defender-for-devops.yml)
[![Coverage Status](https://coveralls.io/repos/github/butlergroup/caddy-ingress/badge.svg?branch=main)](https://coveralls.io/github/butlergroup/caddy-ingress?branch=main)
[![Feature Requests](https://img.shields.io/github/issues/butlergroup/caddy-ingress/feature-request.svg)](https://github.com/butlergroup/caddy-ingress/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement)
[![Bugs](https://img.shields.io/github/issues/butlergroup/caddy-ingress/bug.svg)](https://github.com/butlergroup/caddy-ingress/issues?utf8=✓&q=is%3Aissue+is%3Aopen+label%3Abug)

# Caddy Ingress Controller

This is the Kubernetes Ingress Controller for Caddy. It includes functionality
for monitoring `Ingress` resources on a Kubernetes cluster and includes support
for providing automatic HTTPS certificates for all hostnames defined in the 
ingress resources that it is managing.

## Notes on this fork

- **Modified to write auto-generated certs to the source namespace instead of the Caddy installation namespace. This aligns with established K8s best practices regarding namespace-constrained secret access.** (as of v0.4.0/1.5.0)
- **Modified to work with Cloudflare** (as of v0.3.0/1.4.0)
- Created to update dependencies and include the latest version of Caddy when building the ingress-controller binary
- Several security scanners have been added to the repo to ensure any issues are found quickly
- Will be maintained (depenencies/packages updated & CVEs addressed in a timely manner, etc.)

## Prerequisites

- Helm 3+
- Kubernetes 1.19+

## Setup

In the `charts` folder, a Helm Chart is provided to make installing the Caddy
Ingress Controller on a Kubernetes cluster straightforward. To install the
Caddy Ingress Controller adhere to the following steps:

1. Add the Helm chart:

```sh
helm repo add caddy-ingress http://butlergroup.net/caddy-ingress/
```

2. Create a new namespace in your cluster to isolate all Caddy resources.

```sh
kubectl create namespace caddy-system
```

3. Create a Kubernetes opaque secret named "cloudflare-api-token" with the following key and value:

- CF_API_TOKEN / your Cloudflare API token with Zone.Zone:Read and Zone.DNS:Edit permissions for the domain(s) you're managing with Caddy

```sh
kubectl create secret generic cloudflare-api-token \
  --from-literal=CF_API_TOKEN=your_cloudflare_api_token \
  -n caddy-system
```

4. (a) Install the Helm chart:

```sh
helm install caddy-ingress caddy-ingress/caddy-ingress-controller \
  --namespace=caddy-system 
```

4. (b) Install the Helm chart with on-demand TLS enabled:

```sh
helm install caddy-ingress caddy-ingress/caddy-ingress-controller \
  --namespace=caddy-system \
  --set ingressController.config.email=your@email.com \
  --set ingressController.config.onDemandTLS=true \
  --set ingressController.config.acmeDNSProvider=cloudflare \
  --set ingressController.config.acmeDNSResolvers[0]=1.1.1.1 \
  --set ingressController.config.permissionEndpoint=http://your-permission-endpoint
```

Note: Caddy expects to be able to query a local HTTP endpoint and receive an HTTP 200 OK response
for domains authorized for on-demand TLS. See [this link](https://caddyserver.com/docs/json/apps/tls/automation/on_demand/permission/http) for details. 

This will create a service of type `LoadBalancer` in the `caddy-system`
namespace on your cluster. You'll want to set any DNS records for accessing this
cluster to the external IP address of this `LoadBalancer` when the external IP
is provisioned by your cloud provider.

You can get the external IP address with `kubectl get svc -n caddy-system`

## Debugging

To view any logs generated by Caddy or the Ingress Controller you can view the
pod logs of the Caddy Ingress Controller.

Get the pod name with:

```sh
kubectl get pods -n caddy-system
```

View the pod logs:

```sh
kubectl logs <pod-name> -n caddy-system
```

## Automatic HTTPS

To have automatic HTTPS (not to be confused with `On-demand TLS`), you simply have
to specify your email in the config map. When using Helm chart, you can add
`--set ingressController.config.email=your@email.com` when installing.

## On-Demand TLS

[On-demand TLS](https://caddyserver.com/docs/automatic-https#on-demand-tls) can generate SSL certs on the fly
and can be enabled in this controller by setting the `onDemandTLS` config to `true`:

```sh
helm install ...\
  --set ingressController.config.onDemandTLS=true
```

## Bringing Your Own Certificates

If you would like to disable automatic HTTPS for a specific host and use your
own certificates you can create a new TLS secret in Kubernetes and define what
certificates to use when serving your application on the ingress resource.

Example:

Create TLS secret `mycerts`, where `./tls.key` and `./tls.crt` are valid
certificates for `test.com`.

```
kubectl create secret tls mycerts --key ./tls.key --cert ./tls.crt
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example
  annotations:
    kubernetes.io/ingress.class: caddy
spec:
  rules:
  - host: test.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 8080
  tls:
    - secretName: mycerts # use mycerts for host test.com
      hosts:
        - test.com
```

### Contribution

Learn how to start contributing on the [Contributing Guidline](CONTRIBUTING.md).

## License

[Apache License 2.0](LICENSE.txt)

## Terms of Service

Please read our [Terms of Service](https://github.com/butlergroup/caddy-ingress/blob/main/terms-of-service.md) before using our software. Violators of these Terms are not supported by the community or contributors.

## Privacy Policy

Please also read our [Privacy Policy](https://github.com/butlergroup/caddy-ingress/blob/main/privacy-policy.md) to understand how we handle your personal information. 

## Contact

Have questions or suggestions? Reach out to us at dev@butlergroup.net. Thank you and happy coding! :)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=butlergroup/caddy-ingress&type=Date)](https://www.star-history.com/#butlergroup/caddy-ingress&Date)