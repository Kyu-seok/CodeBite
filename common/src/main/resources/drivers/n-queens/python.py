{USER_CODE}

import json
n = int(input())
result = Solution().solveNQueens(n)
result.sort()
print(json.dumps(result, separators=(',', ':')))
