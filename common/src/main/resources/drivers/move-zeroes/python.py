{USER_CODE}

import json
nums = json.loads(input())
Solution().moveZeroes(nums)
print(json.dumps(nums, separators=(',', ':')))
