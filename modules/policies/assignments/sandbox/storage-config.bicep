targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Storage_Config '../../../shared/policy-assignment.bicep' = {
  name: 'storage-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'storage-config'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-storage-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
