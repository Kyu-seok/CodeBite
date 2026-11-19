{USER_CODE}

import json
links = json.loads(input())
n = int(input())
src = int(input())
result = Solution().minutesToReachAll(links, n, src)
print(result)
