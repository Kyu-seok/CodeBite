{USER_CODE}

import json
s = input().strip()
result = Solution().splitZoneRuns(s)
print(json.dumps(result, separators=(',', ':')))
