targetScope = 'managementGroup'

param location string = deployment().location

module SQL_Entra '../../../../shared/policy-assignment.bicep' = {
  name: 'sql-entra-assignment'
  params: {
    location: location
    policyAssignmentName: 'sql-entra'
    policyDefinitionId: tenantResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      'a55e4a7e-1b9c-43ef-b4b3-642f303804d6'
    )
    parameters: {
      effect: {
        value: 'Audit'
      }
    }
  }
}
