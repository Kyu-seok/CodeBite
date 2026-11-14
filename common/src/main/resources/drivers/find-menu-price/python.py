{USER_CODE}

import json
menu = json.loads(input())
target = int(input())
result = Solution().hasPrice(menu, target)
print(str(result).lower())
