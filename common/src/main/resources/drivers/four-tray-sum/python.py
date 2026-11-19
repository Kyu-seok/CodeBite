{USER_CODE}

import json
trays = json.loads(input())
demand = int(input())
result = Solution().fourTraySum(trays, demand)
result = [sorted(q) for q in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
