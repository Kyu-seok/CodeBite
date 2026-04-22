{USER_CODE}

import json
nums = eval(input())
k = Solution().compactShelf(nums)
print(k)
print(json.dumps(nums[:k], separators=(',', ':')))
