{USER_CODE}

import json
nums = json.loads(input())
Solution().sortMaterials(nums)
print(json.dumps(nums, separators=(',', ':')))
