targetScope = 'managementGroup'

param location string = deployment().location
param identity string

module Function_App_Config '../../shared/policy-assignment.bicep' = {
  name: 'function-app-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'function-app-config'
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policySetDefinitions', 'configure-function-app-security')
    userAssignedIdentity: identity
    parameters: {}
  }
}
