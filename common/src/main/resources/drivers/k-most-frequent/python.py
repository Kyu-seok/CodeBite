{USER_CODE}

import json
nums = eval(input())
k = int(input())
result = Solution().topKFrequent(nums, k)
result.sort()
print(json.dumps(result, separators=(',', ':')))
