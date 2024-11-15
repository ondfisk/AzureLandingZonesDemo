targetScope = 'managementGroup'

param location string = deployment().location

module Cloud_Security_Benchmark '../../../../shared/policy-assignment.bicep' = {
  name: 'cloud-security-benchmark-assignment'
  params: {
    location: location
    policyAssignmentName: 'cloud-security-benchmark'
    policyDefinitionId: tenantResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      '1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
    )
    parameters: {
      networkWatcherShouldBeEnabledResourceGroupName: {
        value: 'Management'
      }
    }
  }
}
