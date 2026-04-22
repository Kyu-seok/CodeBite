{USER_CODE}

import json
nums = json.loads(input())
result = Solution().listStationOrders(nums)
result.sort()
print(json.dumps(result, separators=(',', ':')))
