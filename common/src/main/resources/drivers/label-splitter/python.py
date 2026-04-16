{USER_CODE}

import json
s = input().strip()
result = Solution().splitLabels(s)
print(json.dumps(result, separators=(',', ':')))
