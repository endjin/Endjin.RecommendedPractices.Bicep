@description('The name of the container app hosting environment')
param name string

@description('The location of the container app hosting environment')
param location string

@description('The name of the log analytics workspace used by the container app hosting environment')
param logAnalyticsName string

@description('The name of the app insights workspace used by Dapr-enabled container apps running in the hosting environment')
param appInsightsName string

@description('When true, the details of an existing container app hosting environment will be returned; When false, the container app hosting environment will be created/updated')
param useExisting bool = false

@description('The resource group in which the existing container app hosting environment resides')
param existingAppEnvironmentResourceGroupName string = resourceGroup().name

@description('The subscription in which the existing container app hosting environment resides')
param existingAppEnvironmentSubscriptionId string = subscription().subscriptionId

@description('The resource group in which the existing app insights workspace resides')
param existingAppInsightsResourceGroupName string = existingAppEnvironmentResourceGroupName

@description('The subscription in which the existing app insights workspace resides')
param existingAppInsightsSubscriptionId string = existingAppEnvironmentSubscriptionId

@description('When true, an Azure Container Registry will be provisioned')
param createContainerRegistry bool = false

@description('The name of the container registry')
param containerRegistryName string = '${name}acr'

@description('The SKU for the container registry')
param containerRegistrySku string = 'Standard'

@description('When true, admin access via the ACR key is enabled; When false, access is via RBAC')
param enableContainerRegistryAdminUser bool = true

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


module acr 'acr.bicep' = if (createContainerRegistry) {
  name: 'appEnvAcrDeploy'
  params: {
    name: containerRegistryName
    location: location
    sku: containerRegistrySku
    adminUserEnabled: enableContainerRegistryAdminUser
    resourceTags: resourceTags
  }
}


resource log_analytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = if (!useExisting) {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
  tags: resourceTags
}

resource existing_app_insights 'Microsoft.Insights/components@2020-02-02' existing = if (useExisting) {
  name: appInsightsName
  scope: resourceGroup(existingAppInsightsSubscriptionId, existingAppInsightsResourceGroupName)
}

resource app_insights 'Microsoft.Insights/components@2020-02-02' = if (!useExisting) {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    #disable-next-line BCP036
    Flow_Type: 'Redfield'
    #disable-next-line BCP036
    Request_Source: 'CustomDeployment'
  }
  tags: resourceTags
}


resource existing_container_app_environment 'Microsoft.Web/kubeEnvironments@2021-02-01' existing = if (useExisting) {
  name: name
  scope: resourceGroup(existingAppEnvironmentSubscriptionId, existingAppEnvironmentResourceGroupName)
}

resource container_app_environment 'Microsoft.Web/kubeEnvironments@2021-02-01' =  if (!useExisting) {
  name: name
  location: location
  properties: {
    #disable-next-line BCP037
    type: 'managed'
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: log_analytics.properties.customerId
        sharedKey: listKeys(log_analytics.id, log_analytics.apiVersion).primarySharedKey
      }
    }
    #disable-next-line BCP037
    containerAppsConfiguration: {
      daprAIInstrumentationKey: app_insights.properties.InstrumentationKey
    }
  }
  tags: resourceTags
}

// ContainerApp hosting environment outputs
output id string = useExisting ? existing_container_app_environment.id : container_app_environment.id
output name string = useExisting ? existing_container_app_environment.name : container_app_environment.name
output appEnvironmentResource object = useExisting ? existing_container_app_environment : container_app_environment

// Monitoring resource outputs
output appinsights_instrumentation_key string = useExisting ? existing_app_insights.properties.InstrumentationKey : app_insights.properties.InstrumentationKey

// ACR outputs
output acrId string = createContainerRegistry ? acr.outputs.id : ''
output acrUsername string = createContainerRegistry ? acr.outputs.name : ''
output acrLoginServer string = createContainerRegistry ? acr.outputs.loginServer : ''
