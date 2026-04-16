{USER_CODE}

import json
triplets = json.loads(input())
target = json.loads(input())
result = Solution().canFormTarget(triplets, target)
print(str(result).lower())
