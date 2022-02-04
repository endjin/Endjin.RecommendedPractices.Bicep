# Deployment script to set up a private ACR with Bicep modules

## Requires

**Bicep Tools**

- [Azure PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-powershell)
- [Bicep CLI for PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually).

## Deploy ACR and Publish modules

There are two scripts: 

1. [DeployAcr](./DeployAcr.ps1) to create an Azure Container Registry instance in you given resource group and preferred location
2. [PublishToRegistry](./PublishToRegistry.ps1) to publish Bicep modules to a given ACR instance. 

