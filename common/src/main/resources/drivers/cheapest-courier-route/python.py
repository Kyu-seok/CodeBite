{USER_CODE}

import json
n = int(input())
links = json.loads(input())
src = int(input())
dst = int(input())
maxStops = int(input())
result = Solution().cheapestRoute(n, links, src, dst, maxStops)
print(result)
