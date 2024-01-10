param location string= resourceGroup().location
param identityName string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: identityName
  location: location
}

output principalId string = identity.properties.principalId
