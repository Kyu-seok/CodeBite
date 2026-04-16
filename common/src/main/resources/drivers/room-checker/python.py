{USER_CODE}

import json
intervals = json.loads(input())
result = Solution().canAttendAll(intervals)
print(str(result).lower())
