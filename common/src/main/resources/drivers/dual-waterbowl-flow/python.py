{USER_CODE}

import json

heights = json.loads(input())
result = Solution().traceDualDrainage(heights)
result.sort()
print(json.dumps(result, separators=(',', ':')))
