{USER_CODE}

import json
n = int(input())
result = Solution().fizzBuzz(n)
print(json.dumps(result, separators=(',', ':')))
