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
      publicNetworkAccessOnAzureSQLDatabaseShouldBeDisabledMonitoringEffect: {
        value: 'Disabled'
      }
      publicNetworkAccessShouldBeDisabledForCognitiveServicesAccountsMonitoringEffect: {
        value: 'Disabled'
      }
      publicNetworkAccessShouldBeDisabledForMariaDbServersMonitoringEffect: {
        value: 'Disabled'
      }
      publicNetworkAccessShouldBeDisabledForMySqlServersMonitoringEffect: {
        value: 'Disabled'
      }
      publicNetworkAccessShouldBeDisabledForPostgreSqlServersMonitoringEffect: {
        value: 'Disabled'
      }
      storageAccountShouldUseAPrivateLinkConnectionMonitoringEffect: {
        value: 'Disabled'
      }
      storageAccountsShouldRestrictNetworkAccessUsingVirtualNetworkRulesMonitoringEffect: {
        value: 'Disabled'
      }
      vmImageBuilderTemplatesShouldUsePrivateLinkMonitoringEffect: {
        value: 'Disabled'
      }
    }
  }
}

module Cloud_Security_Benchmark_Exemption '../../../shared/policy-exemption.bicep' = {
  name: 'cloud-security-benchmark-exemption'
  dependsOn: [
    Cloud_Security_Benchmark
  ]
  params: {
    displayName: 'Exemption for cloud security benchmark'
    description: 'We allow public network access and do not enforce the use of private link as all services will have Entra ID authentication and TLS encryption enforced instead.'
    exemptionCategory: 'Mitigated'
    policyExemptionName: 'cloud-security-benchmark-exemption'
    policyAssignmentName: 'cloud-security-benchmark'
    policyDefinitionReferenceIds: [
      'azureSQLManagedInstancesShouldDisablePublicNetworkAccess'
      'azureCosmosDBShouldDisablePublicNetworkAccess'
      'aPIManagementServiceShouldDisableServiceConfigurationEndpoints'
      'azureDatabricksWorkspacesShouldDisablePublicNetworkAccess'
      'azureMachineLearningWorkspacesShouldDisablePublicNetworkAccess'
      'cosmosDBAaccountsShouldUsePrivateLink'
      'azureAIServicesResourcesShouldUseAzurePrivateLinkMonitoring'
      'azureDatabricksWorkspacesShouldUsePrivateLink'
    ]
  }
}
