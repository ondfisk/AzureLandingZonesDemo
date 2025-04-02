targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Container_Registry '../../../shared/policy-assignment.bicep' = {
  name: 'container-registry-assignment'
  params: {
    location: location
    policyAssignmentName: 'container-registry'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-container-registry-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
