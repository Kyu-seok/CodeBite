{USER_CODE}

import json
nums = eval(input())
result = Solution().orderTankDeviations(nums)
print(json.dumps(result, separators=(',', ':')))
