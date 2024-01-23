targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string

module Defender_For_Databases '../../shared/policy-assignment.bicep' = {
  name: 'defender-for-databases-assignment'
  params: {
    location: location
    policyAssignmentName: 'defender-for-databases'
    policyDefinitionId: tenantResourceId('Microsoft.Authorization/policySetDefinitions', '9d46421d-1a48-4636-8d1a-5525ed29172d')
    userAssignedIdentity: managedIdentityId
    parameters: {}
  }
}
