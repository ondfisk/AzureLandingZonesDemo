using '../../modules/management-groups/main.bicep'

param displayName = 'Azure Landing Zones - Canary'

param prefix = 'lz-canary'

param managementSubscriptionId = '8228ddb9-d118-47b4-b4e7-1f1de7667d4d'

param corpSubscriptionIds = []

param onlineSubscriptionIds = []

param onlineOnboardingSubscriptionIds = []

param sandboxSubscriptionIds = []

param decommissionedSubscriptionIds = []
