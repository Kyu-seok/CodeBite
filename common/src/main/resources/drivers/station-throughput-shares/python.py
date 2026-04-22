{USER_CODE}

import json
nums = eval(input())
result = Solution().computeStationShare(nums)
print(json.dumps(result, separators=(',', ':')))
