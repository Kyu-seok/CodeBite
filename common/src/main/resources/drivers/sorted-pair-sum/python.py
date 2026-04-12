{USER_CODE}

import json
numbers = eval(input())
target = int(input())
result = Solution().two_sum(numbers, target)
print(json.dumps(result, separators=(',', ':')))
