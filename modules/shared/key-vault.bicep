param location string = resourceGroup().location
param keyVaultName string
param enabledForDeployment bool = false
param enabledForDiskEncryption bool = false
param enabledForTemplateDeployment bool = false

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
    enabledForDeployment:enabledForDeployment
    enabledForDiskEncryption:enabledForDiskEncryption
    enabledForTemplateDeployment:enabledForTemplateDeployment
    tenantId: tenant().tenantId
    softDeleteRetentionInDays: 90
    enableSoftDelete: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    publicNetworkAccess: 'Enabled'
  }
}

output id string = keyVault.id
