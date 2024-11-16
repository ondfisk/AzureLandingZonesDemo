targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Function_App_Config '../../../shared/policy-assignment.bicep' = {
  name: 'function-app-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'function-app-config'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-function-app-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
