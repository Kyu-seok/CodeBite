{USER_CODE}

import json
nums = json.loads(input())
result = Solution().triageZeroPriority(nums)
result = [sorted(t) for t in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
