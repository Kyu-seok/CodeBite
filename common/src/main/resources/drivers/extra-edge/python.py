{USER_CODE}

import json
edges = json.loads(input())
result = Solution().findExtraEdge(edges)
print(json.dumps(result, separators=(',', ':')))
