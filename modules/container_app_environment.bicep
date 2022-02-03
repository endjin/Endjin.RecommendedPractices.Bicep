param location string
param workspaceName string
param appinsightsName string
param environmentName string

param useExisting bool = false
param existingAppEnvironmentResourceGroupName string = resourceGroup().name
param existingAppEnvironmentSubscriptionId string = subscription().subscriptionId
param existingAppInsightsResourceGroupName string = existingAppEnvironmentResourceGroupName
param existingAppInsightsSubscriptionId string = existingAppEnvironmentSubscriptionId
param createContainerRegistry bool = false
param containerRegistryName string = '${environmentName}acr'
param containerRegistrySku string = 'Standard'
param enableContainerRegistryAdminUser bool = true

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
  name: workspaceName
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
  name: appinsightsName
  scope: resourceGroup(existingAppInsightsSubscriptionId, existingAppInsightsResourceGroupName)
}

resource app_insights 'Microsoft.Insights/components@2020-02-02' = if (!useExisting) {
  name: appinsightsName
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
  name: environmentName
  scope: resourceGroup(existingAppEnvironmentSubscriptionId, existingAppEnvironmentResourceGroupName)
}

resource container_app_environment 'Microsoft.Web/kubeEnvironments@2021-02-01' =  if (!useExisting) {
  name: environmentName
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

output id string = useExisting ? existing_container_app_environment.id : container_app_environment.id
output name string = useExisting ? existing_container_app_environment.name : container_app_environment.name
output appinsights_instrumentation_key string = useExisting ? existing_app_insights.properties.InstrumentationKey : app_insights.properties.InstrumentationKey
output acrId string = createContainerRegistry ? acr.outputs.id : ''
output acrUsername string = createContainerRegistry ? acr.outputs.name : ''
output acrLoginServer string = createContainerRegistry ? acr.outputs.loginServer : ''

output appEnvironmentResource object = useExisting ? existing_container_app_environment : container_app_environment
