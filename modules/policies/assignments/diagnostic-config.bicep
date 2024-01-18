targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string
param logAnalyticsWorkspaceId string

module Diagnostic_Config '../../shared/policy-assignment.bicep' = {
  name: 'diagnostic-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'diagnostic-config'
    policyDefinitionId: extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policySetDefinitions', 'configure-diagnostic-settings')
    userAssignedIdentity: managedIdentityId
    parameters: {
      logAnalytics: {
        value: logAnalyticsWorkspaceId
      }
    }
  }
}
