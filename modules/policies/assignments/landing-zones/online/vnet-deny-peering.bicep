targetScope = 'managementGroup'

param location string = deployment().location

module VNET_Deny_Peering '../../../../shared/policy-assignment.bicep' = {
  name: 'vnet-deny-peering-assignment'
  params: {
    location: location
    policyAssignmentName: 'vnet-deny-peering'
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policyDefinitions', 'vnet-deny-peering')
    parameters: {}
  }
}
