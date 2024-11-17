targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module SQL_Config '../../../shared/policy-assignment.bicep' = {
  name: 'sql-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'sql-config'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-sql-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
