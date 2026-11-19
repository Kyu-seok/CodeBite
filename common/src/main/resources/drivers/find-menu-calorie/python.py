{USER_CODE}

import json
menu = json.loads(input())
target = int(input())
result = Solution().findCalorie(menu, target)
print(str(result).lower())
