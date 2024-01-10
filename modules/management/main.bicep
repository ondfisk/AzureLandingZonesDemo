targetScope = 'managementGroup'

param location string = deployment().location
param managementSubscriptionId string
param resourceGroupName string
param userAssignedIdentityName string
param workspaceName string

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
  dependsOn: [
    userAssignedIdentity
  ]
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
