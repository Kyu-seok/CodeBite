{USER_CODE}

import json
nums = json.loads(input())
Solution().sortColors(nums)
print(json.dumps(nums, separators=(',', ':')))
