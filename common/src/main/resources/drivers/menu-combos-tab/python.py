{USER_CODE}

import json
candidates = json.loads(input())
target = int(input())
result = Solution().listQuotaBatches(candidates, target)
result = [sorted(c) for c in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
