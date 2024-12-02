// <copyright file="rbac-built-in-roles/main.bicep" company="Endjin Limited">
// Copyright (c) Endjin Limited. All rights reserved.
// </copyright>

metadata name = 'RBAC built-in roles'
metadata description = 'Provides a dictionary of role name to role definition ID for built-in RBAC roles.'
metadata owner = 'endjin'

var roleIds = loadJsonContent('arm-roles.json')

var roleDefinitionIdsArray = [for role in items(roleIds): {
  key: role.key
  value: resourceId('Microsoft.Authorization/roleDefinitions', role.value)
}]


@description('Dictionary of role name to role definition ID.')
output roleDefinitionIds object = reduce(roleDefinitionIdsArray, {}, (cur, next) => union(cur, {
  '${next.key}': next.value
}))

