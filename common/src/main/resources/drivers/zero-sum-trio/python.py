{USER_CODE}

import json
deltas = json.loads(input())
result = Solution().zeroSumTrios(deltas)
result = [sorted(t) for t in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
