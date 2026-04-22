{USER_CODE}

import json

intervals = json.loads(input())
result = Solution().min_meeting_rooms(intervals)
print(result)
