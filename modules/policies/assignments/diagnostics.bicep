targetScope = 'managementGroup'

param location string = deployment().location
param managedIdentityId string
param logAnalyticsWorkspaceId string

module Diagnostics '../../shared/policy-assignment.bicep' = {
  name: 'diagnostics-assignment'
  params: {
    location: location
    policyAssignmentName: 'diagnostics'
    policyDefinitionId: managementGroupResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      'configure-diagnostics'
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
