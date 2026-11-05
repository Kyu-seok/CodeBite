{USER_CODE}

import json
nums = json.loads(input())
result = Solution().powerSet(nums)
result = [sorted(s) for s in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
