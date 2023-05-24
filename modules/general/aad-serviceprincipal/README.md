# AAD Service Principal

Creates an AAD service principal

## Description

Deploys a [deployment script resource](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/deploymentscripts?pivots=deployment-language-bicep) that runs a PowerShell script that creates an [Azure Active Directory service principal](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#application-object).

## Parameters

| Name                        | Type     | Required | Description                                                                                          |
| :-------------------------- | :------: | :------: | :--------------------------------------------------------------------------------------------------- |
| `displayName`               | `string` | Yes      | The display name of the AzureAD service principal                                                    |
| `keyVaultName`              | `string` | Yes      | The key vault where the service principal credential details will be stored                          |
| `keyVaultSecretName`        | `string` | Yes      | Name of the key vault secret that will hold where the service principal credential details           |
| `managedIdentityResourceId` | `string` | Yes      | The resource identifier of the managed identity used for the deployment script.                      |
| `location`                  | `string` | No       | The location in which the deployment script will be ran                                              |
| `passwordLifetimeDays`      | `int`    | Yes      | Sets the expiration of any newly-created credentials                                                 |
| `useApplicationCredential`  | `bool`   | No       | When true, the credentials will be added to the AzureAD application instead of the service principal |
| `rotateSecret`              | `bool`   | No       | When true, the existing credentials will be rotated                                                  |
| `credentialDisplayName`     | `string` | No       | The display name metadata for the credential                                                         |
| `resourceTags`              | `object` | No       | The resource tags applied to resources                                                               |

## Outputs

| Name      | Type   | Description                                                |
| :-------- | :----: | :--------------------------------------------------------- |
| app_id    | string | The application/client ID of the AzureAD service principal |
| object_id | string | The object/principal ID of the AzureAD service principal   |

## Examples

### Assert an existing service principal

```bicep
resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing =  {
  name: '<managed-identity-resource-name>'
  scope: resourceGroup('<subscription-id>', '<resource-group-name>')
}

resource key_vault 'Microsoft.KeyVault/vaults@2023-02-01' = existing {
  name: '<key-vault-name>'
  scope: resourceGroup('<subscription-id>', '<resource-group-name>')
}

module aad_sp 'br:<registry-fqdn>/bicep/general/aad-serviceprincipal:<version>' = {
  name: 'aadSpDeploy'
  params: {
    displayName: 'my-service-principal'
    location: location
    managedIdentityResourceId: managed_identity.id
    keyVaultName: key_vault.name
    keyVaultSecretName: 'my-service-principal-credentials'
    passwordLifetimeDays: 90
  }
}
```