targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Key_Vault '../../../shared/policy-assignment.bicep' = {
  name: 'key-vault-assignment'
  params: {
    location: location
    policyAssignmentName: 'key-vault'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-key-vault-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
