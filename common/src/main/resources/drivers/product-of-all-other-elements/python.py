{USER_CODE}

import json
nums = eval(input())
result = Solution().productOfAllOtherElements(nums)
print(json.dumps(result, separators=(',', ':')))
