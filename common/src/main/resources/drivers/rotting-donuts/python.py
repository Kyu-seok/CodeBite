{USER_CODE}

import json

tray = json.loads(input())
result = Solution().minutes_until_stale(tray)
print(result)
