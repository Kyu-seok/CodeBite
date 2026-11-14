{USER_CODE}

import json

shelf = json.loads(input())
result = Solution().spiralOrder(shelf)
print(json.dumps(result, separators=(',', ':')))
