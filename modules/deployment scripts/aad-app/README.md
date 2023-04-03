# AAD App Registration

Creates an AAD app registration

## Description

Deploys a [deployment script resource](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/deploymentscripts?pivots=deployment-language-bicep) that runs a PowerShell script that creates an [AAD application](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#application-object). 

## Parameters

| Name                              |   Type   | Required | Description                                                                                     |
| :-------------------------------- | :------: | :------: | :---------------------------------------------------------------------------------------------- |
| `location`                        | `string` |   Yes    | The location in which the deployment script will be ran                                         |
| `displayName`                     | `string` |   Yes    | The display name of the AzureAD application                                                     |
| `replyUrls`                       | `array`  |    No    | The reply application reply URLs                                                                |
| `appUri`                          | `string` |   Yes    | The URL to the application homepage                                                             |
| `enableAccessTokenIssuance`       |  `bool`  |   Yes    | When true, allows the AzureAD application to issue access tokens (used for implicit flow)       |
| `enableIdTokenIssuance`           |  `bool`  |   Yes    | When true, allows the AzureAD application to issue ID tokens (used for implicit & hybrid flows) |
| `managedIdentityResourceId`       | `string` |   Yes    | The resource identifier of the managed identity used for the deployment script                  |
| `microsoftGraphScopeIdsToGrant`   | `array`  |    No    | Microsoft Graph scope IDs to grant the AzureAD application                                      |
| `microsoftGraphAppRoleIdsToGrant` | `array`  |    No    | Microsoft Graph role IDs to grant the AzureAD application                                       |

## Outputs

| Name          |  Type  | Description                                 |
| :------------ | :----: | :------------------------------------------ |
| applicationId | string | The ID of the AzureAD application           |
| objectId      | string | The object ID of the AzureAD application    |
| displayName   | string | The display name of the AzureAD application |

## Examples

### Example 1

```bicep
module aad_app '../main.bicep' = {
  name: 'aadAppDeploy'
  params: {
    displayName: aadAppDisplayName
    location: location
    replyUrls: replyUrls
    appUri: appUri
    managedIdentityResourceId: managedIdentityResourceId
    enableAccessTokenIssuance: false
    enableIdTokenIssuance: true
    microsoftGraphScopeIdsToGrant: [
      graphScopeId
    ]
    microsoftGraphAppRoleIdsToGrant: []
  }
}
```