{USER_CODE}

import json
nums = eval(input())
result = Solution().productExceptSelf(nums)
print(json.dumps(result, separators=(',', ':')))
