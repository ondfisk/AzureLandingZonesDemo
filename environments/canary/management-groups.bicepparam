using '../../modules/management-groups/main.bicep'

param displayName = 'Azure Landing Zones - Canary'

param prefix = 'lz-canary'

param managementSubscriptionId = '8228ddb9-d118-47b4-b4e7-1f1de7667d4d'

param onlineSubscriptionIds = [
  '0b3ff046-7854-4f2b-a83f-c45dfc89d22d'
]
