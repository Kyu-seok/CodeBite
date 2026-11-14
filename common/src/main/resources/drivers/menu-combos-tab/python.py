{USER_CODE}

import json
pastries = json.loads(input())
tab = int(input())
result = Solution().listTabCombos(pastries, tab)
result = [sorted(c) for c in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
