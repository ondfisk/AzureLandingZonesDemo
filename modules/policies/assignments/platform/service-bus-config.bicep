targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Service_Bus_Config '../../../shared/policy-assignment.bicep' = {
  name: 'service-bus-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'service-bus-config'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-service-bus-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
