{USER_CODE}

import json

n = int(input())
edges = json.loads(input())
result = Solution().count_components(n, edges)
print(result)
