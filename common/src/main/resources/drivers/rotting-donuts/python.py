{USER_CODE}

import json

tray = json.loads(input())
result = Solution().minutesUntilStale(tray)
print(result)
