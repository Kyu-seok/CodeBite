{USER_CODE}

import json

intervals = json.loads(input())
newInterval = json.loads(input())
result = Solution().insert(intervals, newInterval)
print(json.dumps(result, separators=(',', ':')))
