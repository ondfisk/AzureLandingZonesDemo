targetScope = 'managementGroup'

param location string = deployment().location
param policyDefinitionManagementGroupId string

module Virtual_Network '../../../shared/policy-assignment.bicep' = {
  name: 'virtual-network-assignment'
  params: {
    location: location
    policyAssignmentName: 'virtual-network'
    policyDefinitionId: managementGroupResourceId(
      policyDefinitionManagementGroupId,
      'Microsoft.Authorization/policyDefinitions',
      'vnet-deny-peering'
    )
    parameters: {}
  }
}
