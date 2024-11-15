param location string = resourceGroup().location
param storageAccountName string
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param skuName string
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'
param allowSharedKeyAccess bool = false
param allowBlobPublicAccess bool = false
param isHnsEnabled bool = false
param isNfsV3Enabled bool = false
@allowed([
  'Disabled'
  'Enabled'
])
param largeFileSharesState string = 'Disabled'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    allowCrossTenantReplication: false
    allowSharedKeyAccess: allowSharedKeyAccess
    isHnsEnabled: isHnsEnabled
    isLocalUserEnabled: false
    isNfsV3Enabled: isNfsV3Enabled
    isSftpEnabled: false
    largeFileSharesState: largeFileSharesState
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: true
  }
}

output id string = storageAccount.id
