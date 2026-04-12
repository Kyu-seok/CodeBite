{USER_CODE}

import json
matrix = json.loads(input())
target = int(input())
result = Solution().searchMatrix(matrix, target)
print(str(result).lower())
