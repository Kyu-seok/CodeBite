{USER_CODE}

import json
n = int(input())
edges = json.loads(input())
result = Solution().validTree(n, edges)
print(str(result).lower())
