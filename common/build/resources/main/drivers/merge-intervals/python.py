{USER_CODE}

import json
intervals = json.loads(input())
result = Solution().merge(intervals)
print(json.dumps(result, separators=(',', ':')))
