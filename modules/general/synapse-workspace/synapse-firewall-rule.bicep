param workspaceName string
@description('An array of objects defining firewall rules with the structure {name: "rule_name", startAddress="a.b.c.d", endAddress="w.x.y.z"}')
param firewallRules array

targetScope = 'resourceGroup'

resource workspace 'Microsoft.Synapse/workspaces@2021-03-01' existing = {
  name: workspaceName
}

resource firewall_rules 'Microsoft.Synapse/workspaces/firewallRules@2021-03-01' = [for rule in firewallRules : {
  parent: workspace
  name: rule.name
  properties: {
    startIpAddress: rule.startAddress
    endIpAddress: rule.endAddress
  }
}]
