{USER_CODE}

import json
snacks = json.loads(input())
result = Solution().listSnackCombos(snacks)
result = [sorted(s) for s in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
