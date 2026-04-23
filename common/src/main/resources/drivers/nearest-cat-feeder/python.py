{USER_CODE}

import json
grid = json.loads(input())
Solution().fanoutResponderReach(grid)
print(json.dumps(grid, separators=(',', ':')))
