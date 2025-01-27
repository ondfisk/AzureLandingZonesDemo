targetScope = 'managementGroup'

param location string = deployment().location

module SQL_Entra_Config '../../../shared/policy-assignment.bicep' = {
  name: 'sql-entra-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'sql-entra-config'
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
