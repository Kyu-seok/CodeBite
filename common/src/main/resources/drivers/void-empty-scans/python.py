{USER_CODE}

import json
nums = json.loads(input())
Solution().voidEmptyScans(nums)
print(json.dumps(nums, separators=(',', ':')))
