{USER_CODE}

import json
nums = eval(input())
target = int(input())
result = Solution().findPairIndices(nums, target)
if result is not None and len(result) == 2 and result[0] > result[1]:
    result = [result[1], result[0]]
print(json.dumps(result, separators=(',', ':')))
