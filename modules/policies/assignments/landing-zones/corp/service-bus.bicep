targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Service_Bus '../../../../shared/policy-assignment.bicep' = {
  name: 'service-bus-assignment'
  params: {
    location: location
    policyAssignmentName: 'service-bus'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-service-bus-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
