targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Container_Apps '../../../../shared/policy-assignment.bicep' = {
  name: 'container-apps-assignment'
  params: {
    location: location
    policyAssignmentName: 'container-apps'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-container-apps-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
