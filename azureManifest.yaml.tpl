applicationName: caddy-ingress
publisher: "The Butler Group LLC"
description: "A Helm chart for the Caddy Kubernetes ingress controller"
version: __VERSION__
helmChart: "./charts/caddy-ingress-controller"
clusterArmTemplate: "./azureARMTemplate.json"
uiDefinition: "./azureUIDefinition.json"
registryServer: "containerbutler-bxene7duhhe5d8cy.azurecr.io"
extensionRegistrationParameters:
  defaultScope: "cluster" # cluster or namespace 
  namespace: caddy-system
