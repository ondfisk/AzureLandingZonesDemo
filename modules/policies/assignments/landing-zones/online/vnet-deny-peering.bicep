targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string

module VNET_Deny_Peering '../../../../shared/policy-assignment.bicep' = {
  name: 'vnet-deny-peering-assignment'
  params: {
    location: location
    policyAssignmentName: 'vnet-deny-peering'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policyDefinitions',
      'vnet-deny-peering'
    )
    parameters: {}
  }
}
