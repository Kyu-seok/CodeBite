{USER_CODE}

import json
rocks = json.loads(input())
result = Solution().spaceRocks(rocks)
print(json.dumps(result, separators=(',', ':')))
