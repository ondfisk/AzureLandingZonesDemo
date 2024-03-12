targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string

module Key_Vault_Config '../../shared/policy-assignment.bicep' = {
  name: 'key-vault-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'key-vault-config'
    policyDefinitionId: managementGroupResourceId('Microsoft.Authorization/policySetDefinitions', 'configure-key-vault-security')
    userAssignedIdentity: managedIdentityId
    parameters: {}
  }
}
