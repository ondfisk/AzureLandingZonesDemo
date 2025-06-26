targetScope = 'managementGroup'

param location string = deployment().location
param managementSubscriptionId string
param resourceGroupName string
param userAssignedIdentityName string
param workspaceName string
param storageAccountName string
param keyVaultName string

module group '../shared/resource-group.bicep' = {
  scope: subscription(managementSubscriptionId)
  name: 'resource-group-${uniqueString(resourceGroupName)}'
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}

module userAssignedIdentity '../shared/user-assigned-identity.bicep' = {
  scope: resourceGroup(managementSubscriptionId, resourceGroupName)
  name: 'user-assigned-identity-${uniqueString(resourceGroupName, userAssignedIdentityName)}'
  dependsOn: [
    group
  ]
  params: {
    location: location
    identityName: userAssignedIdentityName
  }
}

module userAssignedIdentityRoleAssignment '../shared/management-group-role-assignment.bicep' = {
  name: 'management-group-role-assignment-${uniqueString(managementGroup().id, userAssignedIdentityName)}'
  params: {
    principalId: userAssignedIdentity.outputs.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  }
}

module workspace '../shared/log-analytics-workspace.bicep' = {
  scope: resourceGroup(managementSubscriptionId, resourceGroupName)
  name: 'log-analytics-workspace-${uniqueString(resourceGroupName, workspaceName)}'
  dependsOn: [
    group
  ]
  params: {
    location: location
    workspaceName: workspaceName
  }
}

var solutions = [
  'Security'
  'SecurityCenterFree'
  'SQLAdvancedThreatProtection'
  'SQLVulnerabilityAssessment'
]

module solution '../shared/log-analytics-workspace-solution.bicep' = [for solution in solutions: {
  scope: resourceGroup(managementSubscriptionId,resourceGroupName)
  name: 'log-analytics-workspace-solution-${uniqueString(resourceGroupName, workspaceName, solution)}'
  dependsOn: [
    workspace
  ]
  params: {
    location: location
    logAnalyticsWorkspaceName: workspaceName
    solutionName: solution
  }
}]

module storageAccount '../shared/storage-account.bicep' = {
  scope: resourceGroup(managementSubscriptionId, resourceGroupName)
  name: 'storage-account-${uniqueString(resourceGroupName, storageAccountName)}'
  dependsOn: [
    group
  ]
  params: {
    location: location
    skuName: 'Standard_LRS'
    storageAccountName: storageAccountName
  }
}

module keyVault '../shared/key-vault.bicep' = {
  scope: resourceGroup(managementSubscriptionId, resourceGroupName)
  name: 'key-vault-${uniqueString(resourceGroupName, keyVaultName)}'
  dependsOn: [
    group
  ]
  params: {
    location: location
    keyVaultName: keyVaultName
  }
}
