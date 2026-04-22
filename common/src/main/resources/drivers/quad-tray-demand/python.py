{USER_CODE}

import json
nums = json.loads(input())
target = int(input())
result = Solution().quadTrayDemand(nums, target)
result = [sorted(q) for q in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
