{USER_CODE}

import json
drifts = eval(input())
result = Solution().sortedSquaredDrifts(drifts)
print(json.dumps(result, separators=(',', ':')))
