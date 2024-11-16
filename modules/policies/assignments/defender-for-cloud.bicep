targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string

module Defender_For_Cloud '../../shared/policy-assignment.bicep' = {
  name: 'defender-for-cloud-assignment'
  params: {
    location: location
    policyAssignmentName: 'defender-for-cloud'
    policyDefinitionId: tenantResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      'f08c57cd-dbd6-49a4-a85e-9ae77ac959b0'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
