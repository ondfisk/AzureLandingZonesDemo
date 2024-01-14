targetScope = 'managementGroup'

param location string = deployment().location
param identity string

module Key_Vault_Configuration '../../shared/policy-assignment.bicep' = {
  name: 'key-vault-configuration-assignment'
  params: {
    location: location
    policyAssignmentName: 'key-vault-configuration'
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policySetDefinitions', 'configure-key-vault-security')
    userAssignedIdentity: identity
    parameters: {}
  }
}
