applicationName: caddy-ingress
publisher: "The Butler Group LLC"
description: "A Helm chart for the Caddy Kubernetes Ingress Controller"
version: __VERSION__
helmChart: "./charts/caddy-ingress-controller"
clusterArmTemplate: "./azureARMTemplate.json"
uiDefinition: "./azureUIDefinition.json"
registryServer: __ACR_REGISTRY_SERVER__
extensionRegistrationParameters:
  defaultScope: "cluster" # cluster or namespace 
  namespace: caddy-system
