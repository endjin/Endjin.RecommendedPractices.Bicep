param prefix string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location

module action_group '../../email-action-group/main.bicep' = {
  name: '${prefix}AgDeploy'
  params: {
    name: prefix
    notifyEmailAddresses: [
      'noone@nowhere.org'
    ]
    shortName: prefix
  }
}

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${prefix}-plan'
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: 'B1'
  }
}

resource app 'Microsoft.Web/sites@2021-03-01' = {
  name: '${prefix}-app'
  location: location
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      alwaysOn: true
      ftpsState: 'Disabled'
      appSettings: [
        {
          // Disable persistent storage because we don't need it.
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      // The container image to deploy.
      linuxFxVersion: 'DOCKER|docker.io/nginx:latest'
    }
  }
}

module response_time_alert '../main.bicep' = {
  name: 'deployResponseTimeAlert'
  params: {
    name: 'slow-response-time-alert'
    actionGroupId: action_group.outputs.id
    alertDescription: 'Test dynamic metric alert'
    metricName: 'HttpResponseTime'
    metricNamespace: 'microsoft.web/sites'
    metricTimeAggregation: 'Average'
    metricRuleOperator: 'GreaterThan'
    evaluationFrequencyMinutes: 5
    evaluationWindowSizeMinutes: 5
    severity: 'Warning'
    targetScopes: [
      app.id
    ]
    minimumFailingPeriodsAlertThreshold: 4
    dynamicAlertSensitivity: 'Medium'
  }
}
