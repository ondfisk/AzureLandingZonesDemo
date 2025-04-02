targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module SQL '../../../shared/policy-assignment.bicep' = {
  name: 'sql-assignment'
  params: {
    location: location
    policyAssignmentName: 'sql'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-sql-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
