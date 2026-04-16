{USER_CODE}

import json
nums = eval(input())
result = Solution().findDuplicates(nums)
result.sort()
print(json.dumps(result, separators=(',', ':')))
