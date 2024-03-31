var roleIds = loadJsonContent('arm-roles.json')

var roleDefinitionIdsArray = [for role in items(roleIds): {
  key: role.key
  value: resourceId('Microsoft.Authorization/roleDefinitions', role.value)
}]


@description('Dictionary of role name to role definition ID.')
output roleDefinitionIds object = reduce(roleDefinitionIdsArray, {}, (cur, next) => union(cur, {
  '${next.key}': next.value
}))
