targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string

module App_Configuration '../../../shared/policy-assignment.bicep' = {
  name: 'app-configuration-assignment'
  params: {
    location: location
    policyAssignmentName: 'app-configuration'
    policyDefinitionId: tenantResourceId(
      'Microsoft.Authorization/policyDefinitions',
      '72bc14af-4ab8-43af-b4e4-38e7983f9a1f'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
