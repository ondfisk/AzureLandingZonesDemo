targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string
param logAnalyticsWorkspaceId string

module Diagnostic_Settings '../../shared/policy-assignment.bicep' = {
  name: 'diagnostic-settings-assignment'
  params: {
    location: location
    policyAssignmentName: 'diagnostic-settings'
    policyDefinitionId: managementGroupResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      'configure-diagnostic-settings'
    )
    managedIdentityId: managedIdentityId
    parameters: {
      logAnalyticsWorkspaceId: {
        value: logAnalyticsWorkspaceId
      }
      categoryGroup: {
        value: 'audit'
      }
      defenderForCloudExportResourceGroupName: {
        value: 'Management'
      }
      defenderForCloudExportResourceGroupLocation: {
        value: location
      }
    }
  }
}
