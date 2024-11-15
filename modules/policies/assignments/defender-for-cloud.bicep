targetScope = 'managementGroup'

param location string = deployment().location
param logAnalyticsWorkspaceId string
param managedIdentityId string

module Defender_For_Cloud '../../shared/policy-assignment.bicep' = {
  name: 'defender-for-cloud-assignment'
  params: {
    location: location
    policyAssignmentName: 'defender-for-cloud'
    policyDefinitionId: managementGroupResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      'configure-defender-for-cloud'
    )
    userAssignedIdentity: managedIdentityId
    parameters: {
      logAnalytics: {
        value: logAnalyticsWorkspaceId
      }
      ascExportResourceGroupName: {
        value: 'Management'
      }
      ascExportResourceGroupLocation: {
        value: location
      }
    }
  }
}
