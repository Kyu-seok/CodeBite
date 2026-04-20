{USER_CODE}

import json
numbers = eval(input())
target = int(input())
result = Solution().twoSum(numbers, target)
print(json.dumps(result, separators=(',', ':')))
