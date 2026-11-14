{USER_CODE}

import json
players = json.loads(input())
result = Solution().rebuildLine(players)
print(json.dumps(result, separators=(',', ':')))
