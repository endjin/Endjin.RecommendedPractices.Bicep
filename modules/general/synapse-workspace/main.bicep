// <copyright file="synapse-workspace/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'Synapse workspace'
metadata description = 'Adds/updates a Synapse workspace.'
metadata owner = 'endjin'

@description('The name of the Synapse workspace.')
param workspaceName string

@description('The location of the Synapse workspace.')
param location string = resourceGroup().location

@description('If true, grants SQL control to the workspace managed identity.')
param grantWorkspaceIdentityControlForSql bool = true

@description('Provides the configuration for git-integrated workspaces. Ref: https://learn.microsoft.com/en-us/azure/templates/microsoft.synapse/workspaces?pivots=deployment-language-bicep#workspacerepositoryconfiguration')
param workspaceRepositoryConfiguration object = {}

@description('The name of an existing service principal to set as the SQL Administrator for the workspace. This will be used as the login.')
param sqlAdministratorPrincipalName string

@description('The principal/object ID of an existing service principal to set as the SQL Administrator for the workspace.')
param sqlAdministratorPrincipalId string

@description('If true, the \'azureADOnlyAuthentication\' option will be enabled, enforcing Entra authentication to Synapse SQL endpoints.')
param disableSqlAuth bool = false

@description('If true, enable diagnostics on the workspace (`logAnalyticsWorkspaceId` must also be set).')
param enableDiagnostics bool

@description('When `enableDiagnostics` is true, the workspace ID (resource ID of a Log Analytics workspace) for a Log Analytics workspace to which you would like to send Diagnostic Logs.')
param logAnalyticsWorkspaceId string = ''

@description('The resource tags applied to resources.')
param tagValues object = {}

// Networking parameters

@description('When true, a single firewall rule is configured on the workspace allowing all IP addresses')
param allowAllConnections bool = false

@description('When true, Azure Services will have access to the Synapse workspace even when \'allowAllConnections\' is false')
param allowAzureServices bool = false

@description('When false, the vault will not accept traffic from public internet. (i.e. all traffic except private endpoint traffic and that that originates from trusted services will be blocked, regardless of any firewall rules)')
param enablePublicAccess bool = true

@description('An array of objects defining firewall rules with the structure {name: "rule_name", startAddress: "a.b.c.d", endAddress: "w.x.y.z"}')
param workspaceFirewallRules array = []

@description('If true, will ensure that all compute for this workspace is in a virtual network managed on behalf of the user.')
param managedVirtualNetwork bool = false

@description('SubscriptionId for existing virtual network to use when configuring private endpoints.')
param virtualNetworkSubscriptionId string = subscription().subscriptionId

@description('Resource group name for existing virtual network to use when configuring private endpoints.')
param virtualNetworkResourceGroupName string = ''

@description('Name of existing virtual network to use when configuring private endpoints.')
param virtualNetworkName string = ''

@description('Subnet to use when configuring private endpoints.')
param subnetName string = ''

@description('List of services to configure when enabling private endpoints. If not empty, virtual network related parameters must also be set.')
param enabledSynapsePrivateEndpointServices array = [
  'dev'
  'sql'
  'sqlOnDemand'
]

@description('The resource group name where private endpoints are provisioned. NOTE: Must be in the same subscription as the virtual network')
param privateEndpointResourceGroupName string = virtualNetworkResourceGroupName

@description('When true, the private endpoint sub-resources will be registered with the relevant PrivateDns zone.')
param enablePrivateEndpointsPrivateDns bool

@description('The resource group where PrivateDNs zones will be created or existing zones found.')
param privateDnsZonesResourceGroupName string = virtualNetworkResourceGroupName

@description('The subscriptionId of the PrivateDNs zones.')
param privateDnsZonesSubscriptionId string = subscription().subscriptionId

// Storage parameters

@description('The name of the existing storage account that the default data lake file system will be created in.')
param defaultDataLakeStorageAccountName string

@description('The name of the filesystem to create in the storage account.')
param defaultDataLakeStorageFilesystemName string

@description('If true, grants "Storage Blob Data Contributor" RBAC role for the workspace managed identity on the storage account.')
param setWorkspaceIdentityRbacOnStorageAccount bool

@description('The subscription ID of the existing storage account. Defaults to current subscription, if not set.')
param storageSubscriptionID string = subscription().subscriptionId

@description('The resource group name of the existing storage account. Defaults to current resource group, if not set.')
param storageResourceGroupName string = resourceGroup().name

@description('The Azure AD group ID for the group to assign "Storage Blob Data Contributor" and "Reader" RBAC roles on the storage account resource group.')
param datalakeContributorGroupId string = ''

@description('If true, the group defined by `datalakeContributorGroupId` will be assigned "Storage Blob Data Contributor" and "Reader" RBAC roles on the storage account resource group.')
param setSbdcRbacOnStorageAccount bool = false


var allowAllFirewallRule = {
  name: 'allowAll'
  startAddress: '0.0.0.0'
  endAddress: '255.255.255.255'
}
// NOTE: The documented 'trustedServiceBypassEnabled' property and child resource 'Microsoft.Synapse/workspaces/trustedServiceByPassConfiguration'
//       does not work as intended, this is the workaround.
// Ref: https://github.com/Azure/bicep/issues/8958
var allowAzureServicesFirewallRule = {
  name: 'AllowAllWindowsAzureIps'
  startAddress: '0.0.0.0'
  endAddress: '0.0.0.0'
}
var firewallRules = allowAllConnections ? array(allowAllFirewallRule) : concat(workspaceFirewallRules, (allowAzureServices ? array(allowAzureServicesFirewallRule) : []))
var readerRoleId = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
var storageBlobDataContributorRoleID = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
var defaultDataLakeStorageAccountUrl = 'https://${defaultDataLakeStorageAccountName}.dfs.${environment().suffixes.storage}'


module default_datalake_filesystem './storage-blob-container.bicep' = {
  name: 'defaultDataLakeStorageFilesystemDeploy'
  scope: resourceGroup(storageSubscriptionID, storageResourceGroupName)
  params: {
    containerName: defaultDataLakeStorageFilesystemName
    storageAccountName: defaultDataLakeStorageAccountName
    publicAccess: 'None'
  }
}

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: defaultDataLakeStorageAccountUrl
      filesystem: default_datalake_filesystem.outputs.name
    }
    managedVirtualNetwork: managedVirtualNetwork ? 'default' : ''
    workspaceRepositoryConfiguration: workspaceRepositoryConfiguration
    publicNetworkAccess: enablePublicAccess ? 'Enabled' : 'Disabled'
  }
  tags: tagValues
}

resource workspace_mi_sql_control 'Microsoft.Synapse/workspaces/managedIdentitySqlControlSettings@2021-06-01' = {
  name: 'default'
  parent: workspace
  properties: {
    grantSqlControlToManagedIdentity: {
      desiredState: grantWorkspaceIdentityControlForSql ? 'Enabled' : 'Disabled'
    }
  }
}

resource workspace_sql_admin 'Microsoft.Synapse/workspaces/administrators@2021-06-01' = {
  parent: workspace
  name: 'activeDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: sqlAdministratorPrincipalName
    sid: sqlAdministratorPrincipalId
    tenantId: subscription().tenantId
  }
}

module workspace_firewall_rules './synapse-firewall-rule.bicep' = if (enablePublicAccess && length(firewallRules) > 0) {
  name: 'firewallRulesDeploy'
  params: {
    firewallRules: firewallRules
    workspaceName: workspace.name
  }
}

resource workspace_sql_entra_only_auth 'Microsoft.Synapse/workspaces/azureADOnlyAuthentications@2021-06-01' = {
  name: workspaceName
  parent: workspace
  properties: {
    azureADOnlyAuthentication: disableSqlAuth
  }
}

resource workspace_diagnostic_settings 'microsoft.insights/diagnosticSettings@2016-09-01' = if (enableDiagnostics) {
  name: 'service'
  scope: workspace
  location: location
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'IntegrationPipelineRuns'
        enabled: true
      }
      {
        category: 'IntegrationActivityRuns'
        enabled: true
      }
      {
        category: 'IntegrationTriggerRuns'
        enabled: true
      }
    ]
  }
}

// Default Data Lake Permissions

var synapseMsiRbacBaseString = '${resourceGroup().id}/${defaultDataLakeStorageAccountName}/${storageBlobDataContributorRoleID}/${workspaceName}'
module default_datalake_rbac_msi_data_contrib '../storage-account-rbac/main.bicep' = if (setWorkspaceIdentityRbacOnStorageAccount) {
  name: 'defaultDataLakeRbacMsiDataContribDeploy'
  scope: resourceGroup(storageResourceGroupName)
  params: {
    storageAccountName: defaultDataLakeStorageAccountName
    role: 'Storage Blob Data Contributor'
    assigneeObjectId: workspace.identity.principalId
    principalType: 'ServicePrincipal'
    roleAssignmentId: guid('${synapseMsiRbacBaseString}/${workspace.identity.principalId}')
  }
}

var defaultDataLakeDataContributorRoleAssignmentId = guid('${resourceGroup().id}/${defaultDataLakeStorageAccountName}/${storageBlobDataContributorRoleID}/${datalakeContributorGroupId}/datalake-contributor-group')
module default_datalake_rbac_group_data_contrib '../storage-account-rbac/main.bicep' = if (setSbdcRbacOnStorageAccount) {
  name: 'defaultDataLakeRbacGroupDataContribDeploy'
  scope: resourceGroup(storageSubscriptionID, storageResourceGroupName)
  params: {
    storageAccountName: defaultDataLakeStorageAccountName
    role: 'Storage Blob Data Contributor'
    assigneeObjectId: datalakeContributorGroupId
    principalType: 'Group'
    roleAssignmentId: defaultDataLakeDataContributorRoleAssignmentId
  }
}

var defaultDataLakeReaderRoleAssignmentId = guid('${resourceGroup().id}/${defaultDataLakeStorageAccountName}/${readerRoleId}/${datalakeContributorGroupId}/datalake-contributor-group')
module default_datalake_rbac_group_reader '../storage-account-rbac/main.bicep' = if (setSbdcRbacOnStorageAccount) {
  name: 'defaultDataLakeRbacGroupReaderDeploy'
  scope: resourceGroup(storageSubscriptionID, storageResourceGroupName)
  params: {
    storageAccountName: defaultDataLakeStorageAccountName
    role: 'Reader'
    assigneeObjectId: datalakeContributorGroupId
    principalType: 'Group'
    roleAssignmentId: defaultDataLakeReaderRoleAssignmentId
  }
}


module private_endpoints '../private-endpoint/main.bicep' = [ for service in enabledSynapsePrivateEndpointServices : if (length(enabledSynapsePrivateEndpointServices) > 0) {
  name: 'synapsePrivateEndpoints-${service}'
  scope: resourceGroup(virtualNetworkSubscriptionId, privateEndpointResourceGroupName)
  params: {
    name: 'private-endpoint-synapse-${workspace.name}'
    location: location
    virtualNetworkSubscriptionId: virtualNetworkSubscriptionId
    virtualNetworkResourceGroup: virtualNetworkResourceGroupName
    virtualNetworkName: virtualNetworkName
    subnetName: subnetName
    serviceGroupId: service
    serviceResourceId: workspace.id
    enablePrivateDns: enablePrivateEndpointsPrivateDns
    privateDnsZonesResourceGroup: privateDnsZonesResourceGroupName
    privateDnsZonesSubscriptionId: privateDnsZonesSubscriptionId
    tagValues: tagValues
  }
}]

//
// Additional PrivateDns CNAME entries for SQL-related private endpoints
// These are required as the private endpoint name resolution only works 
// properly with '.database.windows.net' FQDNs rather than the Synapse-specific
// '.sql.azuresynapse.net' FQDNs.
//
// We can't reference the '.database.windows.net' zone when configuring the
// private endpoint as the Synapse SQL-related services seem unable to 
// register themselves on that domain.
//
module sql_cname_records '../private-dns-cname/main.bicep' = if (enablePrivateEndpointsPrivateDns && contains(enabledSynapsePrivateEndpointServices, 'sql')) {
  name: 'sqlCNameDeploy'
  scope: resourceGroup(privateDnsZonesSubscriptionId, privateDnsZonesResourceGroupName)
  params: {
    zoneName: 'privatelink${environment().suffixes.sqlServerHostname}'
    recordName: workspace.name
    recordValue: '${workspace.name}.privatelink.sql.azuresynapse.net'
    recordMetadata: {
      creator: 'Created by MDP provisioning to support private endpoint access to Azure Synapse SQL Pools'
    }
  }
}

module sqlondemand_cname_records '../private-dns-cname/main.bicep' = if (enablePrivateEndpointsPrivateDns && contains(enabledSynapsePrivateEndpointServices, 'sqlOnDemand')) {
  name: 'sqlOnDemandCNameDeploy'
  scope: resourceGroup(privateDnsZonesSubscriptionId, privateDnsZonesResourceGroupName)
  params: {
    zoneName: 'privatelink${environment().suffixes.sqlServerHostname}'
    recordName: '${workspace.name}-ondemand'
    recordValue: '${workspace.name}-ondemand.privatelink.sql.azuresynapse.net'
    recordMetadata: {
      creator: 'Created by MDP provisioning to support private endpoint access to Azure Synapse SQL Serverless Pools'
    }
  }
}

@description('The principal ID of the workspace managed identity.')
output synapseManagedIdentityId string = workspace.identity.principalId

@description('The resource ID of the workspace')
output id string = workspace.id

@description('The name of the workspace')
output name string = workspace.name

// Returns the full workspace resource object (workaround whilst resource types cannot be returned directly)
@description('An object representing the workspace resource')
output workspaceResource object = workspace

