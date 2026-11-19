{USER_CODE}

import json

meetings = json.loads(input())
newMeeting = json.loads(input())
result = Solution().insertMeeting(meetings, newMeeting)
print(json.dumps(result, separators=(',', ':')))
