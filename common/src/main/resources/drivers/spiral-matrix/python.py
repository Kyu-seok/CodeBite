{USER_CODE}

import json

matrix = json.loads(input())
result = Solution().spiralOrder(matrix)
print(json.dumps(result, separators=(',', ':')))
