{USER_CODE}

import json
lineup = json.loads(input())
Solution().nextLineup(lineup)
print(json.dumps(lineup, separators=(',', ':')))
