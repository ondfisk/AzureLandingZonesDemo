targetScope = 'managementGroup'

param location string = deployment().location

module Nic_Deny_Public_IP '../../../../shared/policy-assignment.bicep' = {
  name: 'vnet-deny-peering-assignment'
  params: {
    location: location
    policyAssignmentName: 'vnet-deny-peering'
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policyDefinitions', 'vnet-deny-peering')
    parameters: {}
  }
}
