param location string = resourceGroup().location
param eventHubNamespaceName string
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string
param disableLocalAuth bool = true
param isAutoInflateEnabled bool = false
param kafkaEnabled bool = false
param zoneRedundant bool = false

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: skuName
    tier: skuName
  }
  properties: {
    disableLocalAuth: disableLocalAuth
    isAutoInflateEnabled: isAutoInflateEnabled
    kafkaEnabled: kafkaEnabled
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    zoneRedundant: zoneRedundant
  }
}
