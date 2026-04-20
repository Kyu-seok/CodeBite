{USER_CODE}

import json
n = int(input())
result = Solution().generateParenthesis(n)
result.sort()
print(json.dumps(result, separators=(',', ':')))
