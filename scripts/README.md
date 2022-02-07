# Deployment script to set up a private ACR with Bicep modules

## Requires

**Bicep Tools**

- [Azure PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-powershell)
- [Bicep CLI for PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually).

## Deploy an instance of an ACR

Use [DeployAcr](./DeployAcr.ps1) to create an Azure Container Registry instance in your given resource group and preferred location. 
