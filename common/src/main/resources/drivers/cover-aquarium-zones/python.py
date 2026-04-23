{USER_CODE}

import json

targets = json.loads(input())
result = Solution().find_min_arrows(targets)
print(result)
