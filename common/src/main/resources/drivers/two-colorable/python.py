{USER_CODE}

import json
graph = json.loads(input())
result = Solution().isTwoColorable(graph)
print(str(result).lower())
