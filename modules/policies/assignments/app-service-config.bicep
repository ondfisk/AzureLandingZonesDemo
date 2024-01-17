targetScope = 'managementGroup'

param location string = deployment().location
param identity string

module App_Service_Config '../../shared/policy-assignment.bicep' = {
  name: 'app-service-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'app-service-config'
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policySetDefinitions', 'configure-app-service-security')
    userAssignedIdentity: identity
    parameters: {}
  }
}
