{USER_CODE}

import json
s = input().strip()
result = Solution().restoreIpAddresses(s)
result.sort()
print(json.dumps(result, separators=(',', ':')))
