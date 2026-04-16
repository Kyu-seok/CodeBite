{USER_CODE}

import json
people = json.loads(input())
result = Solution().reconstructQueue(people)
print(json.dumps(result, separators=(',', ':')))
