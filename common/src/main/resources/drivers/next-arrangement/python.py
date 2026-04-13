{USER_CODE}

import json
nums = json.loads(input())
Solution().nextPermutation(nums)
print(json.dumps(nums, separators=(',', ':')))
