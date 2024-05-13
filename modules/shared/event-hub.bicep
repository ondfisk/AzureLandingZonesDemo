param eventHubNamespaceName string
param eventHubName string
@minValue(1)
@maxValue(7)
param messageRetentionInDays int = 1

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' existing = {
  name: eventHubNamespaceName
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2023-01-01-preview' = {
  name: eventHubName
  parent: eventHubNamespace
  properties: {
    messageRetentionInDays: messageRetentionInDays
  }
}
