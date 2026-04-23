{USER_CODE}

import json

intervals = json.loads(input())
newInterval = json.loads(input())
result = Solution().scheduleObservingWindow(intervals, newInterval)
print(json.dumps(result, separators=(',', ':')))
