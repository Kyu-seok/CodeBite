{USER_CODE}

import json
intervals = json.loads(input())
result = Solution().verifyTableBookings(intervals)
print(str(result).lower())
