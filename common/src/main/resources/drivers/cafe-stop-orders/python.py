{USER_CODE}

import json
stops = json.loads(input())
result = Solution().listVisitOrders(stops)
result.sort()
print(json.dumps(result, separators=(',', ':')))
