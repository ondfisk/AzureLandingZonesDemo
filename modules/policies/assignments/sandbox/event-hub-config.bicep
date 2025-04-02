targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Event_Hub_Config '../../../shared/policy-assignment.bicep' = {
  name: 'event-hub-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'event-hub-config'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-event-hub-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
