{USER_CODE}

import json
pairCount = int(input())
result = Solution().listBracketPairings(pairCount)
result.sort()
print(json.dumps(result, separators=(',', ':')))
