targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Event_Hub '../../../shared/policy-assignment.bicep' = {
  name: 'event-hub-assignment'
  params: {
    location: location
    policyAssignmentName: 'event-hub'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-event-hub-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
