{USER_CODE}

import json
tickets = json.loads(input())
target = int(input())
result = Solution().countSignAssignments(tickets, target)
print(result)
