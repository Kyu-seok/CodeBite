{USER_CODE}

import json
readings = eval(input())
result = Solution().daysUntilWarmer(readings)
print(json.dumps(result, separators=(',', ':')))
