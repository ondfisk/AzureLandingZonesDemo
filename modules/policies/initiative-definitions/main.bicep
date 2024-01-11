targetScope = 'managementGroup'

var definitions = [
  loadJsonContent('configure-key-vault-security.json')
]

resource policySetDefinitionResources 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = [for definition in definitions: {
  name: definition.name
  properties: definition.properties
}]
