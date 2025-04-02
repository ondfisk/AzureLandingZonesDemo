targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module App_Service '../../../../shared/policy-assignment.bicep' = {
  name: 'app-service-assignment'
  params: {
    location: location
    policyAssignmentName: 'app-service'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-app-service-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
