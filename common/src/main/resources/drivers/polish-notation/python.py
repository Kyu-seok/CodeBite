{USER_CODE}

import json
tokens = json.loads(input())
result = Solution().evalRPN(tokens)
print(result)
