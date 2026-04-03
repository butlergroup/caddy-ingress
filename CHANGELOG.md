## Helm Chart Version 1.4.11 
## Ingress Controller Version v0.3.11 

#### New Features


#### Improvements


#### Fixes


-----

## Helm Chart Version 1.4.10 (04-02-2026)
## Ingress Controller Version v0.3.10 (04-02-2026)

#### New Features


#### Improvements


#### Fixes
- Modified module import for caddy-dns/cloudflare to point to github.com/butlergroup/caddy-dns-cloudflare to address CVE-2026-22184

-----

## Helm Chart Version 1.4.9 (04-02-2026)
## Ingress Controller Version v0.3.9 (04-02-2026)

#### New Features


#### Improvements
- Updated go.mod dependencies (resolved a vulnerability in go-jose)
- Modified module name to point to github.com/butlergroup/caddy-ingress

#### Fixes
- Removed fsGroup from securityContext in values.yaml

-----

## Helm Chart Version 1.4.8 (03-26-2026)
## Ingress Controller Version v0.3.8 (03-26-2026)

#### New Features


#### Improvements
- Updated go.mod dependencies
- Updated Dockerfile to expose both TCP and UDP port 443 to enable QUIC
- Updated Github action versions in osv-scanner.yml

#### Fixes
- Restored all "securityContext" related settings in values.yaml

-----

## Helm Chart Version 1.4.7 (03-24-2026)
## Ingress Controller Version v0.3.7 (03-24-2026)

#### New Features


#### Improvements


#### Fixes
- Reverted all "securityContext" related settings in values.yaml

-----

## Helm Chart Version 1.4.6 (03-23-2026)
## Ingress Controller Version v0.3.6 (03-23-2026)

#### New Features


#### Improvements


#### Fixes
- Reverted change to values.yaml that dropped all capabilities from "securityContext"

-----

## Helm Chart Version 1.4.5 (03-23-2026)
## Ingress Controller Version v0.3.5 (03-23-2026)

#### New Features


#### Improvements


#### Fixes
- Reverted change to values.yaml that set "readOnlyRootFilesystem"

-----

## Helm Chart Version 1.4.4 (03-23-2026)
## Ingress Controller Version v0.3.4 (03-23-2026)

#### New Features


#### Improvements
- Updated go.mod dependencies

#### Fixes
- Corrected Dockerfile to use /etc/caddy/certs instead of /etc/caddy

-----

## Helm Chart Version 1.4.3 (03-22-2026)
## Ingress Controller Version v0.3.3 (03-22-2026)

#### New Features
- Added badge for Dependabot Updates to README.md

#### Improvements
- Updated go.mod dependencies

#### Fixes


-----

## Helm Chart Version 1.4.2 (03-21-2026)
## Ingress Controller Version v0.3.2 (03-21-2026)

#### New Features


#### Improvements
- Updated go.mod dependencies

#### Fixes


-----

## Helm Chart Version 1.4.1 (03-19-2026)
## Ingress Controller Version v0.3.1 (03-19-2026)

#### New Features
- Added code-of-conduct.md
- Added OSV scanner to workflows

#### Improvements
- Updated go.mod dependencies

#### Fixes
- Modified Helm chart values to enhance security 

-----

## Helm Chart Version 1.4.0 (03-19-2026)
## Ingress Controller Version v0.3.0 (03-19-2026)

#### New Features
- Added .github/CODEOWNERS
- Added .github/FUNDING.yml
- Added .github/ISSUE_TEMPLATE/bug_report.md
- Added .github/ISSUE_TEMPLATE/feature_request.md
- Added .github/workflows/defender-for-devops.yml
- Added .github/workflows/scorecard.yml
- Added SECURITY.md
- Added charts/caddy-ingress-controller/templates/cloudflare-secret.yaml to ensure CI tests pass
- Added internal/caddy/plugins.go to wire the Cloudflare DNS plugin into the ingress controller logic
- Added privacy-policy.md
- Added terms-of-service.md

#### Improvements
- Modified .github/workflows/main.yml workflow with permission and concurrency settings
- Modified .github/workflows/main.yml workflow to use latest Go version (1.26.1)
- Modified .github/workflows/main.yml workflow to run on multiple platforms
- Modified .github/workflows/main.yml workflow to include test coverage analysis via Coveralls (goveralls)
- Modified .github/workflows/main.yml workflow to pull test image from this repo
- Modified .github/workflows/release-chart.yml workflow with permission and concurrency settings
- Modified .github/workflows/release-controller.yml workflow with permission and concurrency settings
- Modified .github/workflows/release-controller.yml workflow to use latest Go version (1.26.1)
- Modified .github/workflows/release-controller.yml workflow to not automate Helm chart versioning
- Modified .goreleaser.yaml to include version parameter, removed skip_push parameter, and altered Docker images to point to this repo
- Modified Dockerfile to handle user creation, port binding, and not run as root
- Modified README.md to include badges for workflows, notes on this fork, and updated instructions for installing the Helm chart
- Modified README.md to include Terms of Service, Privacy Policy, Contact Info, and Star History
- Modified charts/caddy-ingress-controller/Chart.yaml to point to this repo and instate a newer version
- Modified charts/caddy-ingress-controller/README.md to include updated instructions for installing the Helm chart 
- Modified charts/caddy-ingress-controller/README.md.gotmpl to include updated instructions for installing the Helm chart 
- Modified charts/caddy-ingress-controller/templates/clusterrole.yaml to reduce permissions granted for better security
- Modified charts/caddy-ingress-controller/templates/deployment.yaml to include UDP port 443 to enable QUIC and to pull ENV values from values.yaml
- Modified charts/caddy-ingress-controller/templates/loadbalancer.yaml to include UDP port 443 to enable QUIC and restrict "loadBalancerSourceRanges" to Cloudflare IP ranges
- Modified charts/caddy-ingress-controller/values.yaml to reduce replica count to 1, point to this repo, and include updated controller version
- Modified charts/caddy-ingress-controller/values.yaml to pull the "CF_API_TOKEN" value from a Kubernetes secret named cloudflare-api-token
- Modified charts/caddy-ingress-controller/values.yaml to include new Cloudflare DNS-related fields in the ConfigMap (acmeDNSProvider, acmeDNSResolvers, permissionEndpoint)
- Modified internal/caddy/global/configmap.go to map Cloudflare DNS-related fields (acmeDNSProvider, acmeDNSResolvers, permissionEndpoint) from pkg/store/configmap_parser.go and pipe them into the acmeIssuer.Challenges.DNS config. Also modified tlsApp.Automation to use the Permission module instead of the Ask module.
- Modified pkg/store/configmap_parser.go to include new Cloudflare DNS-related fields (acmeDNSProvider, acmeDNSResolvers, permissionEndpoint)
- Updated go.mod dependencies to latest and to use latest Go version (1.26.1)
- Updated go.mod dependencies to import github.com/caddy-dns/cloudflare

#### Fixes
- Modified Dockerfile to upgrade zlib to address CVE-2026-22184
