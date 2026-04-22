{USER_CODE}

import json
n = int(input())
result = Solution().tallyPriorityFlags(n)
print(json.dumps(result, separators=(',', ':')))
