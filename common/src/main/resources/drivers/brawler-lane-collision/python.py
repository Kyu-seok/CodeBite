{USER_CODE}

import json
rocks = json.loads(input())
result = Solution().resolveLaneCrashes(rocks)
print(json.dumps(result, separators=(',', ':')))
