{USER_CODE}

import json
grid = json.loads(input())
Solution().gateDistance(grid)
print(json.dumps(grid, separators=(',', ':')))
