targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string

module App_Service_Config '../../../shared/policy-assignment.bicep' = {
  name: 'app-service-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'app-service-config'
    policyDefinitionId: managementGroupResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      'configure-app-service-security'
    )
    userAssignedIdentity: managedIdentityId
    parameters: {}
  }
}
