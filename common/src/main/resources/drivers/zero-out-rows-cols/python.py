{USER_CODE}

import json
matrix = json.loads(input())
Solution().clearDefectRows(matrix)
print(json.dumps(matrix, separators=(',', ':')))
