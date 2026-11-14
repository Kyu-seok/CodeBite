{USER_CODE}

import json

points = json.loads(input())
k = int(input())
result = Solution().selectNearestStops(points, k)
result.sort()
print(json.dumps(result, separators=(',', ':')))
