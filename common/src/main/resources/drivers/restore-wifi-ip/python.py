{USER_CODE}

import json
digits = input().strip()
result = Solution().restoreIpAddresses(digits)
result.sort()
print(json.dumps(result, separators=(',', ':')))
