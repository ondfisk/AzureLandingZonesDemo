targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Cosmos_DB '../../../../shared/policy-assignment.bicep' = {
  name: 'cosmos-db-assignment'
  params: {
    location: location
    policyAssignmentName: 'cosmos-db'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-cosmos-db-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
