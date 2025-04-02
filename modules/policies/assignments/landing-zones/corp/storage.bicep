targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Storage '../../../../shared/policy-assignment.bicep' = {
  name: 'storage-assignment'
  params: {
    location: location
    policyAssignmentName: 'storage'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-storage-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
