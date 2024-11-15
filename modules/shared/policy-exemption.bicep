targetScope = 'managementGroup'

param policyExemptionName string
param displayName string = ''
param description string = ''
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string
param expiresOn string = ''
param policyAssignmentName string
param policyDefinitionReferenceIds array = []
param resourceSelectors array = []

resource policyExemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: policyExemptionName
  properties: {
    displayName: displayName
    description: description
    exemptionCategory: exemptionCategory
    expiresOn: expiresOn
    policyAssignmentId: managementGroupResourceId('Microsoft.Authorization/policyAssignments', policyAssignmentName)
    policyDefinitionReferenceIds: policyDefinitionReferenceIds
    resourceSelectors: resourceSelectors
  }
}
