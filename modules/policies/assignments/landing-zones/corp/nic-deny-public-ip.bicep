targetScope = 'managementGroup'

param location string = deployment().location

module Nic_Deny_Public_IP '../.././../../shared/policy-assignment.bicep' = {
  name: 'nic-deny-public-ip-assignment'
  params: {
    location: location
    policyAssignmentName: 'nic-deny-public-ip'
    policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '83a86a26-fd1f-447c-b59d-e51f44264114')
    parameters: {}
  }
}
