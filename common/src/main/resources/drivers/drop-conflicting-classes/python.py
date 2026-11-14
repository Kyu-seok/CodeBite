{USER_CODE}

import json

intervals = json.loads(input())
result = Solution().dropClassConflicts(intervals)
print(result)
