{USER_CODE}

import json

points = json.loads(input())
result = Solution().min_cost(points)
print(result)
