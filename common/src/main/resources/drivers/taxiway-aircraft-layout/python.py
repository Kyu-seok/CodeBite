{USER_CODE}

import json
n = int(input())
result = Solution().placeAircraft(n)
result.sort()
print(json.dumps(result, separators=(',', ':')))
