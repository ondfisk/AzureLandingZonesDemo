targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Key_Vault_Config '../../../../shared/policy-assignment.bicep' = {
  name: 'key-vault-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'key-vault-config'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-key-vault-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
