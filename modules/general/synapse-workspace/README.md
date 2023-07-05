# Synapse workspace

Adds/updates a Synapse workspace.

## Description

Deploys an Azure Synapse workspace. The following features are also supported via parameters:

- Configuring GitHub or Azure DevOps git repository for the workspace
- Configuring private endpoints for the workspace
- Enabling Log Analytics diagnostics for the workspace
- Configuring linked Azure Data Lake Storage account
- Setting firewall rules on the workspace

## Parameters

| Name                                       | Type     | Required | Description                                                                                                                                                                                                     |
| :----------------------------------------- | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workspaceName`                            | `string` | Yes      | The name of the Synapse workspace.                                                                                                                                                                              |
| `location`                                 | `string` | No       | The location of the Synapse workspace.                                                                                                                                                                          |
| `grantWorkspaceIdentityControlForSql`      | `bool`   | No       | If true, grants SQL control to the workspace managed identity.                                                                                                                                                  |
| `workspaceRepositoryConfiguration`         | `object` | No       | Provides the configuration for git-integrated workspaces. Ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.synapse/workspaces?pivots=deployment-language-bicep#workspacerepositoryconfiguration |
| `sqlAdministratorPrincipalName`            | `string` | Yes      | The name of an existing service principal to set as the SQL Administrator for the workspace. This will be used as the login.                                                                                    |
| `sqlAdministratorPrincipalId`              | `string` | Yes      | The principal/object ID of an existing service principal to set as the SQL Administrator for the workspace.                                                                                                     |
| `enableDiagnostics`                        | `bool`   | Yes      | If true, enable diagnostics on the workspace (`logAnalyticsWorkspaceId` must also be set).                                                                                                                      |
| `logAnalyticsWorkspaceId`                  | `string` | No       | When `enableDiagnostics` is true, the workspace ID (resource ID of a Log Analytics workspace) for a Log Analytics workspace to which you would like to send Diagnostic Logs.                                    |
| `tagValues`                                | `object` | No       | The resource tags applied to resources.                                                                                                                                                                         |
| `allowAllConnections`                      | `bool`   | No       | When true, a single firewall rule is configured on the workspace allowing all IP addresses                                                                                                                      |
| `workspaceFirewallRules`                   | `array`  | No       | An array of objects defining firewall rules with the structure {name: "rule_name", startAddress: "a.b.c.d", endAddress: "w.x.y.z"}                                                                              |
| `managedVirtualNetwork`                    | `bool`   | No       | If true, will ensure that all compute for this workspace is in a virtual network managed on behalf of the user.                                                                                                 |
| `virtualNetworkSubscriptionId`             | `string` | No       | SubscriptionId for existing virtual network to use when configuring private endpoints.                                                                                                                          |
| `virtualNetworkResourceGroupName`          | `string` | No       | Resource group name for existing virtual network to use when configuring private endpoints.                                                                                                                     |
| `virtualNetworkName`                       | `string` | No       | Name of existing virtual network to use when configuring private endpoints.                                                                                                                                     |
| `subnetName`                               | `string` | No       | Subnet to use when configuring private endpoints.                                                                                                                                                               |
| `enabledSynapsePrivateEndpointServices`    | `array`  | No       | List of services to configure when enabling private endpoints. If not empty, virtual network related parameters must also be set.                                                                               |
| `enablePrivateEndpointsPrivateDns`         | `bool`   | Yes      | When true, the private endpoint sub-resources will be registered with the relevant PrivateDns zone.                                                                                                             |
| `defaultDataLakeStorageAccountName`        | `string` | Yes      | The name of the existing storage account that the default data lake file system will be created in.                                                                                                             |
| `defaultDataLakeStorageFilesystemName`     | `string` | Yes      | The name of the filesystem to create in the storage account.                                                                                                                                                    |
| `setWorkspaceIdentityRbacOnStorageAccount` | `bool`   | Yes      | If true, grants "Storage Blob Data Contributor" RBAC role for the workspace managed identity on the storage account.                                                                                            |
| `storageSubscriptionID`                    | `string` | No       | The subscription ID of the existing storage account. Defaults to current subscription, if not set.                                                                                                              |
| `storageResourceGroupName`                 | `string` | No       | The resource group name of the existing storage account. Defaults to current resource group, if not set.                                                                                                        |
| `datalakeContributorGroupId`               | `string` | No       | The Azure AD group ID for the group to assign "Storage Blob Data Contributor" and "Reader" RBAC roles on the storage account resource group.                                                                    |
| `setSbdcRbacOnStorageAccount`              | `bool`   | No       | If true, the group defined by `datalakeContributorGroupId` will be assigned "Storage Blob Data Contributor" and "Reader" RBAC roles on the storage account resource group.                                      |

## Outputs

| Name                     | Type   | Description                                         |
| :----------------------- | :----: | :-------------------------------------------------- |
| synapseManagedIdentityId | string | The principal ID of the workspace managed identity. |
| id                       | string | The resource ID of the workspace                    |
| name                     | string | The name of the workspace                           |
| workspaceResource        | object | An object representing the workspace resource       |

## Examples

### Deploy a Synapse workspace

This example deploys the workspace, configures RBAC roles, configures private endpoints, and configures a Azure DevOps git repository for the workspace.

```bicep
module synapse 'br:<registry-fqdn>/bicep/general/synapse-workspace:<version>' = {
  name: 'synapseDeploy'
  params: {
    location: location
    workspaceName: 'mysynapseworkspace'
    defaultDataLakeStorageAccountName: 'myadlsaccount'
    defaultDataLakeStorageFilesystemName: 'myfilesystem'
    setWorkspaceIdentityRbacOnStorageAccount: true
    sqlAdministratorPrincipalId: '00000000-0000-0000-0000-000000000000' // replace with service principal object ID
    sqlAdministratorPrincipalName: 'my-service-principal'
    virtualNetworkResourceGroupName: 'my-vnet-resource-group'
    virtualNetworkName: 'myvnet'
    subnetName: 'mysubnet'
    workspaceFirewallRules: [
      {
        name: 'example'
        startAddress: '1.2.3.4'
        endAddress: '1.2.3.4'
      }
    ]
    grantWorkspaceIdentityControlForSql: true
    workspaceRepositoryConfiguration: {
        accountName: 'MyADOAccount'
        collaborationBranch: 'main'
        projectName: 'MyProject'
        repositoryName: 'MyRepo'
        rootFolder: 'synapse'
        tenantId: '00000000-0000-0000-0000-000000000000' // replace with AAD tenant ID,
        type: 'WorkspaceVSTSConfiguration'
    }
  }
}
```