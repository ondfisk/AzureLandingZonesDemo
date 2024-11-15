targetScope = 'managementGroup'

param location string = deployment().location

module Cloud_Security_Benchmark '../../../shared/policy-assignment.bicep' = {
  name: 'cloud-security-benchmark-assignment'
  params: {
    location: location
    policyAssignmentName: 'cloud-security-benchmark'
    policyDefinitionId: tenantResourceId(
      'Microsoft.Authorization/policySetDefinitions',
      '1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
    )
    parameters: {
      aPIManagementServicesShouldUseAVirtualNetworkMonitoringEffect: {
        value: 'Disabled'
      }
      appConfigurationShouldUsePrivateLinkMonitoringEffect: {
        value: 'Disabled'
      }
      azureCacheForRedisShouldUsePrivateEndpointMonitoringEffect: {
        value: 'Disabled'
      }
      azureEventGridDomainsShouldUsePrivateLinkMonitoringEffect: {
        value: 'Disabled'
      }
      azureEventGridTopicsShouldUsePrivateLinkMonitoringEffect: {
        value: 'Disabled'
      }
      azureMachineLearningWorkspacesShouldUsePrivateLinkMonitoringEffect: {
        value: 'Disabled'
      }
      azureSignalRServiceShouldUsePrivateLinkMonitoringEffect: {
        value: 'Disabled'
      }
      containerRegistriesShouldNotAllowUnrestrictedNetworkAccessMonitoringEffect: {
        value: 'Disabled'
      }
      containerRegistriesShouldUsePrivateLinkMonitoringEffect: {
        value: 'Disabled'
      }
      identityRemoveExternalAccountWithReadPermissionsMonitoringEffect: {
        value: 'Disabled'
      }
      identityRemoveExternalAccountWithWritePermissionsMonitoringEffect: {
        value: 'Disabled'
      }
      networkWatcherShouldBeEnabledResourceGroupName: {
        value: 'Management'
      }
      privateEndpointConnectionsOnAzureSQLDatabaseShouldBeEnabledMonitoringEffect: {
        value: 'Disabled'
      }
      privateEndpointShouldBeConfiguredForKeyVaultMonitoringEffect: {
        value: 'Disabled'
      }
      privateEndpointShouldBeEnabledForMariadbServersMonitoringEffect: {
        value: 'Disabled'
      }
      privateEndpointShouldBeEnabledForMysqlServersMonitoringEffect: {
        value: 'Disabled'
      }
      privateEndpointShouldBeEnabledForPostgresqlServersMonitoringEffect: {
        value: 'Disabled'
      }
      storageAccountShouldUseAPrivateLinkConnectionMonitoringEffect: {
        value: 'Disabled'
      }
      vmImageBuilderTemplatesShouldUsePrivateLinkMonitoringEffect: {
        value: 'Disabled'
      }
    }
  }
}
