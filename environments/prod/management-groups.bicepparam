using '../../modules/management-groups/main.bicep'

param displayName = 'Azure Landing Zones'

param prefix = 'lz'

param managementSubscriptionId = 'eaf860488-0876-485b-a1f1-da887f980cc6'

param corpSubscriptionIds = []

param onlineSubscriptionIds = []

param sandboxSubscriptionIds = []

param decommissionedSubscriptionIds = []
