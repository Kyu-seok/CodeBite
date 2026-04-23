{USER_CODE}

import json
nums = eval(input())
target = int(input())
result = Solution().findPairIndices(nums, target)
print(json.dumps(result, separators=(',', ':')))
