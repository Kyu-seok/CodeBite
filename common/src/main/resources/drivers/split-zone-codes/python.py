{USER_CODE}

import json
s = input().strip()
result = Solution().splitZoneCodes(s)
result.sort()
print(json.dumps(result, separators=(',', ':')))
