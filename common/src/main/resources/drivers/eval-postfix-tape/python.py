{USER_CODE}

import json
tokens = json.loads(input())
result = Solution().evalPostfix(tokens)
print(result)
