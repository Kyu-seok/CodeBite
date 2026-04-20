{USER_CODE}

import json
temperatures = eval(input())
result = Solution().dailyTemperatures(temperatures)
print(json.dumps(result, separators=(',', ':')))
