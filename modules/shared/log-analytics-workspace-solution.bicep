param location string = resourceGroup().location
param solutionName string
param logAnalyticsWorkspaceName string

resource solution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: '${solutionName}(${logAnalyticsWorkspaceName})'
  location: location
  plan: {
    name: '${solutionName}(${logAnalyticsWorkspaceName})'
    product: 'OMSGallery/${solutionName}'
    promotionCode: ''
    publisher: 'Microsoft'
  }
  properties: {
    workspaceResourceId: resourceId('Microsoft.OperationalInsights/workspaces', logAnalyticsWorkspaceName)
  }
}
