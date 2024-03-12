param location string= resourceGroup().location
param identityName string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

output principalId string = identity.properties.principalId
