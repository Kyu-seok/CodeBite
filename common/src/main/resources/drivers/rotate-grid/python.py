{USER_CODE}

import json
matrix = json.loads(input())
Solution().rotate(matrix)
print(json.dumps(matrix, separators=(',', ':')))
