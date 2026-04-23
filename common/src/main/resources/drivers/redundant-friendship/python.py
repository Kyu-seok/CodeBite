{USER_CODE}

import json
edges = json.loads(input())
result = Solution().spotRedundantLink(edges)
print(json.dumps(result, separators=(',', ':')))
