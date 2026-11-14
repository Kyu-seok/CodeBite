{USER_CODE}

import json
scans = json.loads(input())
Solution().moveVoidsToEnd(scans)
print(json.dumps(scans, separators=(',', ':')))
