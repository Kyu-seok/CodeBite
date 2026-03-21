{USER_CODE}

import json
nums = json.loads(input())
result = Solution().permute(nums)
result.sort()
print(json.dumps(result, separators=(',', ':')))
