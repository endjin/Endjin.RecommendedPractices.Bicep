@description('The name of the app insights workspace')
param name string

@description('The location of the app insights workspace')
param location string

@description('The kind of application using the workspace')
@allowed([
  'web'
  'ios'
  'other'
  'store'
  'java'
  'phone'
])
param kind string = 'web'

@description('The type of application using the workspace')
@allowed([
  'other'
  'web'
])
param applicationType string = 'web'
param flowType string = 'Redfield'
param requestSource string = 'CustomDeployment'

@description('When true, the details of an existing app configuration store will be returned; When false, the app configuration store is created/udpated')
param useExisting bool = false

@description('The resource tags applied to resources')
param resourceTags object = {}


targetScope = 'resourceGroup'


resource existing_app_insights 'Microsoft.Insights/components@2020-02-02' existing = if (useExisting) {
  name: name
}

resource app_insights 'Microsoft.Insights/components@2020-02-02' = if (!useExisting) {
  name: name
  location: location
  kind: kind
  properties: {
    Application_Type: applicationType
    Flow_Type: flowType
    Request_Source: requestSource
  }
  tags: resourceTags
}

output id string = useExisting ? existing_app_insights.id : app_insights.id
output instrumentationKey string =  useExisting ? existing_app_insights.properties.InstrumentationKey : app_insights.properties.InstrumentationKey

output appInsightsWorkspaceResource object = useExisting ? existing_app_insights : app_insights
