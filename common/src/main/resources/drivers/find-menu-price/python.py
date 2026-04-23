{USER_CODE}

import json
matrix = json.loads(input())
target = int(input())
result = Solution().detectFlowValue(matrix, target)
print(str(result).lower())
