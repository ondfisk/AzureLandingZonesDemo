targetScope = 'managementGroup'

param location string = deployment().location
// @maxLength(24)
param policyAssignmentName string
param policyAssignmentDisplayName string = ''
param policyAssignmentDescription string = ''
param policyDefinitionId string
param managedIdentityId string = ''
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'
param parameters object = {}
param notScopes array = []

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: policyAssignmentName
  location: location
  identity: empty(managedIdentityId) ? { type: 'None' } : {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
  properties: {
    displayName: empty(policyAssignmentDisplayName) ? reference(policyDefinitionId, '2023-04-01').displayName : policyAssignmentDisplayName
    description: empty(policyAssignmentDescription) ? reference(policyDefinitionId, '2023-04-01').description : policyAssignmentDescription
    enforcementMode: enforcementMode
    policyDefinitionId: policyDefinitionId
    parameters: parameters
    notScopes: notScopes
  }
}
