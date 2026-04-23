{USER_CODE}

import json
nums = eval(input())
k = int(input())
result = Solution().busiestMachines(nums, k)
result.sort()
print(json.dumps(result, separators=(',', ':')))
