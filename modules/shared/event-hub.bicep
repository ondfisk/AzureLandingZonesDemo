param eventHubNamespaceName string
param eventHubName string
@minValue(1)
@maxValue(7)
param messageRetentionInDays int = 1

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2024-01-01' existing = {
  name: eventHubNamespaceName
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  name: eventHubName
  parent: eventHubNamespace
  properties: {
    messageRetentionInDays: messageRetentionInDays
  }
}
