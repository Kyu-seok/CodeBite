{USER_CODE}

import json
n = int(input())
result = Solution().labelLaneScans(n)
print(json.dumps(result, separators=(',', ':')))
