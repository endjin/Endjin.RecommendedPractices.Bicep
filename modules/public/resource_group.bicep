param name string
param location string
param useExisting bool = false
param resourceTags object = {}


targetScope = 'subscription'


resource existing_rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = if (useExisting) {
  name: name
}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = if (!useExisting) {
  name: name
  location: location
  tags: resourceTags
}

output name string = name
output id string = useExisting ?  existing_rg.id : rg.id

output resourceGroupResource object = rg
