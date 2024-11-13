targetScope = 'tenant'

param displayName string = 'Azure Landing Zones'
param prefix string
param managementSubscriptionId string = '00000000-0000-0000-0000-000000000000'
param connectivitySubscriptionId string = '00000000-0000-0000-0000-000000000000'
param identitySubscriptionId string = '00000000-0000-0000-0000-000000000000'
param corpSubscriptionIds array = []
param onlineSubscriptionIds array = []
param sandboxSubscriptionIds array = []
param decommissionedSubscriptionIds array = []

resource tenantRoot 'Microsoft.Management/managementGroups@2023-04-01' existing = {
  name: tenant().tenantId
}

resource root 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: prefix
  properties: {
    displayName: displayName
    details: {
      parent: {
        id: tenantRoot.id
      }
    }
  }
}

resource platform 'Microsoft.Management/managementGroups@2023-04-01' = {
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

resource management 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${prefix}-platform-management'
  properties: {
    displayName: 'Management'
    details: {
      parent: {
        id: platform.id
      }
    }
  }
}

resource managementSubscription 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = if (managementSubscriptionId != '00000000-0000-0000-0000-000000000000') {
  name: managementSubscriptionId
  parent: management
}

resource connectivity 'Microsoft.Management/managementGroups@2023-04-01' = {
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

resource connectivitySubscription 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = if (connectivitySubscriptionId != '00000000-0000-0000-0000-000000000000') {
  name: connectivitySubscriptionId
  parent: connectivity
}

resource identity 'Microsoft.Management/managementGroups@2023-04-01' = {
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

resource identitySubscription 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = if (identitySubscriptionId != '00000000-0000-0000-0000-000000000000') {
  name: identitySubscriptionId
  parent: identity
}

resource landingZones 'Microsoft.Management/managementGroups@2023-04-01' = {
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

resource corp 'Microsoft.Management/managementGroups@2023-04-01' = {
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

resource corpSubscription 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
  for subscriptionId in corpSubscriptionIds: {
    name: subscriptionId
    parent: corp
  }
]

resource online 'Microsoft.Management/managementGroups@2023-04-01' = {
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

resource onlineSubscription 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
  for subscriptionId in onlineSubscriptionIds: {
    name: subscriptionId
    parent: online
  }
]

resource sandbox 'Microsoft.Management/managementGroups@2023-04-01' = {
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

resource sandboxSubscription 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
  for subscriptionId in sandboxSubscriptionIds: {
    name: subscriptionId
    parent: sandbox
  }
]

resource decommissioned 'Microsoft.Management/managementGroups@2023-04-01' = {
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

resource decommissionedSubscription 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
  for subscriptionId in decommissionedSubscriptionIds: {
    name: subscriptionId
    parent: decommissioned
  }
]
