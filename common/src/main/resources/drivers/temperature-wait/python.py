{USER_CODE}

import json
temperatures = eval(input())
result = Solution().daily_temperatures(temperatures)
print(json.dumps(result, separators=(',', ':')))
