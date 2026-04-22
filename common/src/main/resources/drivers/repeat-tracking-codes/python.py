{USER_CODE}

import json
nums = eval(input())
result = Solution().listRepeatedCodes(nums)
result.sort()
print(json.dumps(result, separators=(',', ':')))
