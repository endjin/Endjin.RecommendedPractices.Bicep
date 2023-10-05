@description('The metric Alert resource name.')
param name string

@description('Defines the criteria that must be true to fire the Alert.')
param allOfCriteria array

@description('Action Group resource Id to invoke when the Alert fires.')
param actionGroupId string

@description('The type of metric Alert criteria')
@allowed([
  'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
  'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  // NOTE: The following is not currently supported by this module
  // 'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
])
param criteriaType string = 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'

@description('The description of the alert')
param alertDescription string = ''

@description('The flag which indicates whether this Alert query is enabled')
param enabled bool

@description('How often the Alert query is evaluated, in minutes.')
param evaluationFrequencyMinutes int

@description('The period of time on which the Alert query will be executed, in minutes.')
param evaluationWindowSizeMinutes int = evaluationFrequencyMinutes

@description('The list of resource id\'s that this Alert is scoped to.')
param targetScopes array

@description('The flag that indicates whether the alert should be auto resolved or not. The default is true.')
param autoMitigate bool = false

@description('The severity of the alert.')
@allowed([
  'Critical'
  'Error'
  'Warning'
  'Informational'
  'Verbose'
])
param severity string


module alert_utils '../../../modules-internal/alerting-helpers.bicep' = {
  name: 'alertUtils_${severity}'
  params: {
    severity: severity
    evaluationFrequencyMinutes: evaluationFrequencyMinutes
    evaluationWindowSizeMinutes: evaluationWindowSizeMinutes
  }
}


resource alert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: name
  location: 'global'
  properties: {
    criteria: {
      allOf: allOfCriteria
      'odata.type': any(criteriaType)
    }
    description: alertDescription
    enabled: enabled
    evaluationFrequency: alert_utils.outputs.evaluationFrequency
    scopes: targetScopes
    severity: alert_utils.outputs.severity
    windowSize: alert_utils.outputs.evaluationWindowSize
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
    autoMitigate: autoMitigate
  }
}

@description('The resource ID of the alert')
output id string = alert.id
