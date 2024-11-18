targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string
param managedIdentityId string

module Cosmos_DB_Config '../../../shared/policy-assignment.bicep' = {
  name: 'cosmos-db-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'cosmos-db-config'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policySetDefinitions',
      'configure-cosmos-db-security'
    )
    managedIdentityId: managedIdentityId
    parameters: {}
  }
}
