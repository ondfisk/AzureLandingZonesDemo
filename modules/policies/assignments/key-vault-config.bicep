targetScope = 'managementGroup'

param location string = deployment().location
param identity string

module Key_Vault_Config '../../shared/policy-assignment.bicep' = {
  name: 'key-vault-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'key-vault-config'
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policySetDefinitions', 'configure-key-vault-security')
    userAssignedIdentity: identity
    parameters: {}
  }
}
