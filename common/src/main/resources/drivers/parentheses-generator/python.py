{USER_CODE}

import json
n = int(input())
result = Solution().generate_parenthesis(n)
result.sort()
print(json.dumps(result, separators=(',', ':')))
