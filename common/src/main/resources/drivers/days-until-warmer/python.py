{USER_CODE}

import json
temperatures = eval(input())
result = Solution().daysToUpgrade(temperatures)
print(json.dumps(result, separators=(',', ':')))
