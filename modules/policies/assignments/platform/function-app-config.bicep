targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string

module Function_App_Config '../../shared/policy-assignment.bicep' = {
  name: 'function-app-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'function-app-config'
    policyDefinitionId: managementGroupResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      'configure-function-app-security'
    )
    userAssignedIdentity: managedIdentityId
    parameters: {}
  }
}
