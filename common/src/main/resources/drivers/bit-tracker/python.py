{USER_CODE}

import json
n = int(input())
result = Solution().countBits(n)
print(json.dumps(result, separators=(',', ':')))
