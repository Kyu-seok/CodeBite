{USER_CODE}

import json
routes = json.loads(input())
result = Solution().planWalk(routes)
print(json.dumps(result, separators=(',', ':')))
