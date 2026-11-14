{USER_CODE}

import json
prices = json.loads(input())
result = Solution().maxProfit(prices)
print(result)
