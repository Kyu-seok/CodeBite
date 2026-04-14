{USER_CODE}

import json

heights = json.loads(input())
result = Solution().pacificAtlantic(heights)
result.sort()
print(json.dumps(result, separators=(',', ':')))
