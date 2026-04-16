{USER_CODE}

import json
rooms = json.loads(input())
result = Solution().canVisitAllRooms(rooms)
print(str(result).lower())
