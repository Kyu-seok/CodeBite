{USER_CODE}

import json
matrix = json.loads(input())
target = int(input())
result = Solution().probeSugarReading(matrix, target)
print(str(result).lower())
