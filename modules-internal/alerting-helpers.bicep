@description('The severity level of the alert')
@allowed([
  'Critical'
  'Error'
  'Warning'
  'Informational'
  'Verbose'
])
param severity string

@description('The frequency at which the alert is evaluated, in minutes')
param evaluationFrequencyMinutes int

@description('The window size used to evaluate the alert, in minutes')
param evaluationWindowSizeMinutes int = evaluationFrequencyMinutes


var severityLookup = {
  critical: 0
  error: 1
  warning: 2
  informational: 3
  verbose: 4
}

@description('The numeric representation of the specified severity level')
output severity int = severityLookup[severity]

@description('The \'evaluationFrequency\' in ISO 8601 duration format')
output evaluationFrequency string = 'PT${evaluationFrequencyMinutes}M'

@description('The \'evaluationWindowSize\' in ISO 8601 duration format')
output evaluationWindowSize string = 'PT${evaluationWindowSizeMinutes}M'
