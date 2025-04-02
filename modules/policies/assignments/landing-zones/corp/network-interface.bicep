targetScope = 'managementGroup'

param location string = deployment().location

module Network_Interface '../../../../shared/policy-assignment.bicep' = {
  name: 'network-interface-assignment'
  params: {
    location: location
    policyAssignmentName: 'network-interface'
    policyDefinitionId: tenantResourceId(
      'Microsoft.Authorization/policyDefinitions',
      '83a86a26-fd1f-447c-b59d-e51f44264114'
    )
    parameters: {}
  }
}
