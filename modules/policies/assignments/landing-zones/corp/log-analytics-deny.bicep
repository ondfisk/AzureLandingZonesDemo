targetScope = 'managementGroup'

param location string = deployment().location

module Log_Analytics_Deny '../../../../shared/policy-assignment.bicep' = {
  name: 'log-analytics-deny-assignment'
  params: {
    location: location
    policyAssignmentName: 'log-analytics-deny'
    policyAssignmentDisplayName: 'Deny creation of Log Analytics workspaces'
    policyAssignmentDescription: 'This policy assignment denies the creation of Log Analytics workspaces. All logs should be sent to the central workspace deployed in the Management subscription.'
    policyDefinitionId: tenantResourceId(
      'Microsoft.Authorization/policyDefinitions',
      '6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
    )
    parameters: {
      listOfResourceTypesNotAllowed: {
        value: [
          'Microsoft.OperationalInsights/workspaces'
        ]
      }
    }
  }
}
