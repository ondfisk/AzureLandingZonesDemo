targetScope = 'tenant'

param rootManagementGroupDisplayName string = 'Azure Landing Zones'
param prefix string
param managementSubscriptionId string

resource tenantRoot 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: tenant().tenantId
}

resource root 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: prefix
  properties: {
    displayName: rootManagementGroupDisplayName
    details: {
      parent: {
        id: tenantRoot.id
      }
    }
  }
}

resource decommissioned 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-decommissioned'
  properties: {
    displayName: 'Decommissioned'
    details: {
      parent: {
        id: root.id
      }
    }
  }
}

resource landingZones 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-landing-zones'
  properties: {
    displayName: 'Landing Zones'
    details: {
      parent: {
        id: root.id
      }
    }
  }
}

resource corp 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-landing-zones-corp'
  properties: {
    displayName: 'Corp'
    details: {
      parent: {
        id: landingZones.id
      }
    }
  }
}

resource online 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-landing-zones-online'
  properties: {
    displayName: 'Online'
    details: {
      parent: {
        id: landingZones.id
      }
    }
  }
}

resource platform 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-platform'
  properties: {
    displayName: 'Platform'
    details: {
      parent: {
        id: root.id
      }
    }
  }
}

resource connectivity 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-platform-connectivity'
  properties: {
    displayName: 'Connectivity'
    details: {
      parent: {
        id: platform.id
      }
    }
  }
}

resource identity 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-platform-identity'
  properties: {
    displayName: 'Identity'
    details: {
      parent: {
        id: platform.id
      }
    }
  }
}

resource management 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-platform-management'
  properties: {
    displayName: 'Management'
    details: {
      parent: {
        id: platform.id
      }
    }
  }

  resource subscription 'subscriptions' = {
    name: managementSubscriptionId
  }
}

resource sandbox 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: '${prefix}-sandbox'
  properties: {
    displayName: 'Sandbox'
    details: {
      parent: {
        id: root.id
      }
    }
  }
}
