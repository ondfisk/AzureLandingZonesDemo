targetScope = 'subscription'

param resourceGroupName string
param location string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

output id string = resourceGroup.id
