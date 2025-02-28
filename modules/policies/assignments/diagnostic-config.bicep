targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string
param logAnalyticsWorkspaceId string

module Diagnostic_Config '../../shared/policy-assignment.bicep' = {
  name: 'diagnostic-config-assignment'
  params: {
    location: location
    policyAssignmentName: 'diagnostic-config'
    policyDefinitionId: managementGroupResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      'configure-diagnostic-settings'
    )
    managedIdentityId: managedIdentityId
    parameters: {
      logAnalyticsWorkspaceId: {
        value: logAnalyticsWorkspaceId
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
