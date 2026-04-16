{USER_CODE}

import json
nums = eval(input())
result = Solution().sortedSquares(nums)
print(json.dumps(result, separators=(',', ':')))
