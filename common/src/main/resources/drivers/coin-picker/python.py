{USER_CODE}

import json
coins = json.loads(input())
amount = int(input())
print(Solution().coinChange(coins, amount))
