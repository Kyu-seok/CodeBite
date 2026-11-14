{USER_CODE}

import json

n = int(input())
relays = json.loads(input())
result = Solution().countParties(n, relays)
print(result)
