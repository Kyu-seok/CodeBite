{USER_CODE}

import json
n = int(input())
edges = json.loads(input())
result = Solution().isAcyclicNetwork(n, edges)
print(str(result).lower())
