# AAD App Registration

Creates an AAD app registration

## Description

Deploys a [deployment script resource](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/deploymentscripts?pivots=deployment-language-bicep) that runs a PowerShell script that creates an [AAD application](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#application-object).

For more details about the structure of the object used with the `appRoles` parameter, please refer to the example below and/or the relevant [Microsoft documentation](https://learn.microsoft.com/en-us/graph/api/resources/approle?view=graph-rest-1.0).

## Parameters

| Name                                 | Type     | Required | Description                                                                                     |
| :----------------------------------- | :------: | :------: | :---------------------------------------------------------------------------------------------- |
| `location`                           | `string` | Yes      | The location in which the deployment script will be ran                                         |
| `displayName`                        | `string` | Yes      | The display name of the AzureAD application                                                     |
| `replyUrls`                          | `array`  | No       | The reply application reply URLs                                                                |
| `appUri`                             | `string` | Yes      | The URL to the application homepage                                                             |
| `enableAccessTokenIssuance`          | `bool`   | Yes      | When true, allows the AzureAD application to issue access tokens (used for implicit flow)       |
| `enableIdTokenIssuance`              | `bool`   | Yes      | When true, allows the AzureAD application to issue ID tokens (used for implicit & hybrid flows) |
| `managedIdentityResourceId`          | `string` | Yes      | The resource identifier of the managed identity used for the deployment script                  |
| `microsoftGraphScopeIdsToGrant`      | `array`  | No       | Microsoft Graph scope IDs to grant the AzureAD application                                      |
| `microsoftGraphAppRoleIdsToGrant`    | `array`  | No       | Microsoft Graph role IDs to grant the AzureAD application                                       |
| `appRoles`                           | `array`  | No       | Microsoft Graph AppRoles exposed by the AzureAD application                                     |
| `corvusModulePackageVersion`         | `string` | No       | Set this parameter to use a custom version of the Corvus.Deployment module                      |
| `allowPrereleaseCorvusModuleVersion` | `bool`   | No       | Enable this if you need to use a pre-release version of the Corvus.Deployment module            |

## Outputs

| Name          | Type   | Description                                 |
| :------------ | :----: | :------------------------------------------ |
| applicationId | string | The ID of the AzureAD application           |
| objectId      | string | The object ID of the AzureAD application    |
| displayName   | string | The display name of the AzureAD application |

## Examples

### Create an AzureAD app, using an existing managed identity

```bicep
resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing =  {
  name: '<managed-identity-resource-name>'
  scope: resourceGroup('<subscription-id>', '<resource-group-name>')
}

module aad_app 'br:<registry-fqdn>/bicep/general/aad-app:<version>' = {
  name: 'aadAppDeploy'
  params: {
    displayName: aadAppDisplayName
    location: location
    replyUrls: replyUrls
    appUri: appUri
    managedIdentityResourceId: managed_identity.id
    enableAccessTokenIssuance: false
    enableIdTokenIssuance: true
    microsoftGraphScopeIdsToGrant: [
      graphScopeId
    ]
    microsoftGraphAppRoleIdsToGrant: []
  }
}
```

### Create an AzureAD app with AppRoles, using an existing managed identity

```bicep
resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing =  {
  name: '<managed-identity-resource-name>'
  scope: resourceGroup('<subscription-id>', '<resource-group-name>')
}

module aad_app 'br:<registry-fqdn>/bicep/general/aad-app:<version>' = {
  name: 'aadAppDeploy'
  params: {
    displayName: aadAppDisplayName
    location: location
    replyUrls: replyUrls
    appUri: appUri
    managedIdentityResourceId: managed_identity.id
    enableAccessTokenIssuance: false
    enableIdTokenIssuance: true
    microsoftGraphScopeIdsToGrant: [
      graphScopeId
    ]
    microsoftGraphAppRoleIdsToGrant: []
    appRoles: [
      {
        roleId: 'bcaf9595-6d17-42b3-98ab-def86b7c7d2d'
        displayName: 'Administrator'
        description: 'Able to administer the service'
        value: 'Admin'
        allowedMemberTypes: [
            'User'
            'Application'
        ]
      }
    ]
  }
}
```