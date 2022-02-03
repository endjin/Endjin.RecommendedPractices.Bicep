param name string
param location string
@allowed([
  'web'
  'ios'
  'other'
  'store'
  'java'
  'phone'
])
param kind string = 'web'
@allowed([
  'other'
  'web'
])
param applicationType string = 'web'
param flowType string = 'Redfield'
param requestSource string = 'CustomDeployment'
param useExisting bool = false
param resourceTags object = {}

targetScope = 'resourceGroup'

resource existing_app_insights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: name
}

resource app_insights 'Microsoft.Insights/components@2020-02-02' = {
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
output instrumentation_key string =  useExisting ? existing_app_insights.properties.InstrumentationKey : app_insights.properties.InstrumentationKey
output app_insights_workspace object = useExisting ? existing_app_insights : app_insights
