using '../../modules/management-groups/main.bicep'

param displayName = 'Azure Landing Zones - Canary'

param prefix = 'lz-canary'

param managementSubscriptionId = '402a4061-2a43-4d20-a60d-957adae8f22e'

param corpSubscriptionIds = []

param onlineSubscriptionIds = ['8287fed1-c40b-4760-9d44-fd175745ed42']

param sandboxSubscriptionIds = []

param decommissionedSubscriptionIds = []
