# Deployment script to set up a private ACR with Bicep modules

## Requires

**Bicep Tools**

- [Azure PowerShell module](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-powershell)
- [Bicep CLI for PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually).

**Sign in to Azure**

If you aren't already logged-in to Azure PowerShell and connected to the relevant subscription, use:
- `Connect-AzAccout` to sign in interactively
- `Set-AzContext -Subscription <subscription-id> -Tenant <tenant-id>` to set the relevant subscription

## Deploy an instance of an ACR

Use [DeployAcr](./DeployAcr.ps1) to create an Azure Container Registry instance in your given resource group and preferred location. 

`./DeployAcr -ResourceGroupName <your-resource-group> -Location <resource-group-location> -AcrName <unique-acr-name>`