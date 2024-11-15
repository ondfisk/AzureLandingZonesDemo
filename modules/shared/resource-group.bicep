targetScope = 'subscription'

param resourceGroupName string
param location string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

output id string = resourceGroup.id
