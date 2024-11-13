using '../../modules/management-groups/main.bicep'

param displayName = 'Azure Landing Zones'

param prefix = 'lz'

param managementSubscriptionId = 'e678d35b-125e-41ad-ae35-c04dfd4162e5'

param corpSubscriptionIds = []

param onlineSubscriptionIds = [
  '2b554ca5-5009-4849-9b8b-730a9820de6a'
  'bd0c76c9-58a6-4c33-bda2-5dc48915446e'
]

param sandboxSubscriptionIds = []

param decommissionedSubscriptionIds = []
