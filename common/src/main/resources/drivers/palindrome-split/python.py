{USER_CODE}

import json
s = input().strip()
result = Solution().partition(s)
result.sort()
print(json.dumps(result, separators=(',', ':')))
