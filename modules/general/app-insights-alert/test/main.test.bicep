var location = 'uksouth'


module appinsights '../../app-insights/main.bicep' = {
  name: 'appInsights'
  params:{
    name: 'appInsights'
    location: location
  }
}

module appinsightsalert '../main.bicep' = {
  name: 'appInsightsAlert'
  params: {
    alertName: 'testalert'
    timeAggregation: 'Count'
    appInsightsResourceId: appinsights.outputs.id
    query: 'requests\n| where resultCode == 500\n| count'
    operator: 'GreaterThan'
    threshold: 0
    evaluationFrequency: 'PT5M'
    alertLocation: location
  }
}
