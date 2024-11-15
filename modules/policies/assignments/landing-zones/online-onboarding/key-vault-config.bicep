targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string

module Key_Vault_Config '../../../../shared/policy-assignment.bicep' = {
  name: 'key-vault-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'key-vault-config'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policyDefinitions',
      'key-vault-configure-rbac-authorization'
    )
    parameters: {
      effectType: {
        value: 'Audit'
      }
    }
  }
}
