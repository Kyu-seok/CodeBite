{USER_CODE}

import json
n = int(input())
result = Solution().listSlateSequences(n)
result.sort()
print(json.dumps(result, separators=(',', ':')))
