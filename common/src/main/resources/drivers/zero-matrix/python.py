{USER_CODE}

import json
matrix = json.loads(input())
Solution().setZeroes(matrix)
print(json.dumps(matrix, separators=(',', ':')))
