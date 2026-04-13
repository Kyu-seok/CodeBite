{USER_CODE}

import json
nums = eval(input())
k = int(input())
result = Solution().max_sliding_window(nums, k)
print(json.dumps(result, separators=(',', ':')))
