{USER_CODE}

import json
nums = eval(input())
k = int(input())
result = Solution().maxSlidingWindow(nums, k)
print(json.dumps(result, separators=(',', ':')))
