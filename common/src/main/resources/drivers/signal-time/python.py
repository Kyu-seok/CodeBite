{USER_CODE}

import json
edges = json.loads(input())
n = int(input())
src = int(input())
result = Solution().signalTime(edges, n, src)
print(result)
