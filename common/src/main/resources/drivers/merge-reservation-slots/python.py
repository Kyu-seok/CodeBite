{USER_CODE}

import json
intervals = json.loads(input())
result = Solution().mergeSeatingWindows(intervals)
print(json.dumps(result, separators=(',', ':')))
