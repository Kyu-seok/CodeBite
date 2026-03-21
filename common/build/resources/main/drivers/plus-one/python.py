{USER_CODE}

import json
digits = json.loads(input())
result = Solution().plusOne(digits)
print(json.dumps(result, separators=(',', ':')))
