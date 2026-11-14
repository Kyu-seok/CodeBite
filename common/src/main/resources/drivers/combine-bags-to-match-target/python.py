{USER_CODE}

import json
bags = json.loads(input())
target = json.loads(input())
result = Solution().canMatchTarget(bags, target)
print(str(result).lower())
