{USER_CODE}

import json
digits = json.loads(input())
result = Solution().bumpParcelCode(digits)
print(json.dumps(result, separators=(',', ':')))
