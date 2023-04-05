# aad-group-membership

Configures the membership of an Azure AD group

## Description

This module creates a `deploymentScript` resource which runs the [`Assert-AzureAdGroupMembership` cmdlet](https://github.com/corvus-dotnet/Corvus.Deployment/blob/main/module/functions/azure/aad/Assert-AzureAdGroupMembership.ps1) from the [`Corvus.Deployment` module](https://github.com/corvus-dotnet/Corvus.Deployment).

The `deploymentScript` will run under the managed identity specified by `managedIdentityResourceId`, which must have permission to manage users in the Azure AD group specified by `groupName`.

The Azure AD group must be located in the same Azure AD tenant as the deployment.

## Parameters

| Name                        | Type     | Required | Description                                                                                                                                                       |
| :-------------------------- | :------: | :------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                  | `string` | Yes      | The location for the deployment script resource.                                                                                                                  |
| `managedIdentityResourceId` | `string` | Yes      | The resource ID for the Managed Identity (MI) that the deployment script will run as. The MI must have permission to manage users in the target Azure AD group.   |
| `groupName`                 | `string` | Yes      | The display name of the Azure AD group to assert membership on.                                                                                                   |
| `requiredMembers`           | `array`  | No       | The list of Azure AD objects that should be members of the group. These can be specified using 'DisplayName', 'ObjectId', 'ApplicationId' or 'UserPrincipalName'. |
| `strictMode`                | `bool`   | No       | When true, existing group members not specified in the `requiredMembers` parameters will be removed from the group.                                               |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Assert group membership, using an existing Managed Identity

```bicep
resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' existing =  {
  name: '<managed-identity-resource-name>'
  scope: resourceGroup('<subscription-id>', '<resource-group-name>')
}

module aad_group_membership 'br:<registry-fqdn>/bicep/general/aad-group-membership:<version>' = {
  name: 'aadGroupMembership'
  params: {
    location: location
    managedIdentityResourceId: managed_identity.id
    groupName: '<aad-group-name>'
    requiredMembers: [
      'foo.bar@endjin.com'
      '6a2ef55b-d13e-4765-876a-435d6444130a'
      'Some User'
    ]
  }
}
```