{USER_CODE}

import json
n = int(input())
flights = json.loads(input())
src = int(input())
dst = int(input())
k = int(input())
result = Solution().relayDispatchCost(n, flights, src, dst, k)
print(result)
