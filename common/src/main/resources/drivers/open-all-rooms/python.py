{USER_CODE}

import json
rooms = json.loads(input())
result = Solution().checkKeyReachability(rooms)
print(str(result).lower())
