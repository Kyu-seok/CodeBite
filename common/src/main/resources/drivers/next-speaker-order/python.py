{USER_CODE}

import json
nums = json.loads(input())
Solution().advanceShotOrder(nums)
print(json.dumps(nums, separators=(',', ':')))
