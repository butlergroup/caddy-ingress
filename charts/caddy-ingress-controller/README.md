# caddy-ingress-controller

A helm chart for the Caddy Kubernetes ingress controller

## TL;DR:

```bash
kubectl create namespace caddy-system

kubectl create secret generic cloudflare-api-token \
  --from-literal=CF_API_TOKEN=your_cloudflare_api_token \
  -n caddy-system

curl -fsSL https://raw.githubusercontent.com/butlergroup/caddy-ingress/main/install_caddy_ingress.sh | \
bash -s -- \
  --namespace=caddy-system 
```

## Introduction

This chart bootstraps a caddy-ingress-controller deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Helm 3+
- Kubernetes 1.19+

## Installing the Chart

1. Create a new namespace in your cluster to isolate all Caddy resources.

```sh
kubectl create namespace caddy-system
```

2. Create a Kubernetes opaque secret named "cloudflare-api-token" with the following key and value:

- CF_API_TOKEN / your Cloudflare API token with Zone.Zone:Read and Zone.DNS:Edit permissions for the domain(s) you're managing with Caddy

```sh
kubectl create secret generic cloudflare-api-token \
  --from-literal=CF_API_TOKEN=your_cloudflare_api_token \
  -n caddy-system
```

3. (a) Install the Helm chart:

```sh
curl -fsSL https://raw.githubusercontent.com/butlergroup/caddy-ingress/main/install_caddy_ingress.sh | \
bash -s -- \
  --namespace=caddy-system 
```

3. (b) Install the Helm chart with on-demand TLS enabled & custom values:

```sh
curl -fsSL https://raw.githubusercontent.com/butlergroup/caddy-ingress/main/install_caddy_ingress.sh | \
bash -s -- \
  --namespace=caddy-system \
  --set ingressController.config.email=your@email.com \
  --set ingressController.config.onDemandTLS=true \
  --set ingressController.config.acmeDNSProvider=cloudflare \
  --set ingressController.config.acmeDNSResolvers[0]=1.1.1.1 \
  --set ingressController.config.permissionEndpoint=http://your-permission-endpoint
```

Note: Caddy expects to be able to query a local HTTP endpoint and receive an HTTP 200 OK response
for domains authorized for on-demand TLS. See [this link](https://caddyserver.com/docs/json/apps/tls/automation/on_demand/permission/http) for details. 

## Uninstalling the Chart

To uninstall `caddy-ingress`:

```console
$ helm uninstall caddy-ingress
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: List all releases using `helm list` or start clean with `helm uninstall caddy-ingress`

## Additional Configuration

## Troubleshooting

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"butlergroup/caddy-ingress"` |  |
| image.tag | string | `"latest"` |  |
| imagePullSecrets | list | `[]` |  |
| ingressController.config.acmeCA | string | `""` |  |
| ingressController.config.acmeEABKeyId | string | `""` |  |
| ingressController.config.acmeEABMacKey | string | `""` |  |
| ingressController.config.debug | bool | `false` |  |
| ingressController.config.email | string | `""` |  |
| ingressController.config.metrics | bool | `true` |  |
| ingressController.config.onDemandTLS | bool | `false` |  |
| ingressController.config.proxyProtocol | bool | `false` |  |
| ingressController.rbac.create | bool | `true` |  |
| ingressController.verbose | bool | `false` |  |
| ingressController.leaseId | string | `""` |  |
| ingressController.watchNamespace | string | `""` |  |
| minikube | bool | `false` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.maxUnavailable | string | `nil` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `2` |  |
| resources | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `true` |  |
| securityContext.capabilities.add[0] | string | `"NET_BIND_SERVICE"` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.runAsGroup | int | `0` |  |
| securityContext.runAsUser | int | `0` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"caddy-ingress-controller"` |  |
| tolerations | list | `[]` |  |