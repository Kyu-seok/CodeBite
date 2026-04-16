{USER_CODE}

import json
tickets = json.loads(input())
result = Solution().find_itinerary(tickets)
print(json.dumps(result, separators=(',', ':')))
