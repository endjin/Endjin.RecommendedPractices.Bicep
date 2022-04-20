/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

module keyvault '../main.bicep' = {
  name: 'fake-kv-deploy'
  params: {
    enableDiagnostics: false
    name: 'fake-kv'
    secretsContributorsGroupObjectId: '00000000-0000-0000-0000-000000000000'
    secretsReadersGroupObjectId: '00000000-0000-0000-0000-000000000000'
    tenantId: '00000000-0000-0000-0000-000000000000'
#disable-next-line no-hardcoded-location
    location: 'northeurope'
  }
}
