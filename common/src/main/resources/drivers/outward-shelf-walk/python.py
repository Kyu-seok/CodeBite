{USER_CODE}

import json

matrix = json.loads(input())
result = Solution().traceOutwardWalk(matrix)
print(json.dumps(result, separators=(',', ':')))
