{USER_CODE}

import json
people = json.loads(input())
result = Solution().orderTicketHolders(people)
print(json.dumps(result, separators=(',', ':')))
