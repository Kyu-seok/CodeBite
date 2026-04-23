{USER_CODE}

import json
numbers = eval(input())
target = int(input())
result = Solution().pairTiersBudget(numbers, target)
print(json.dumps(result, separators=(',', ':')))
