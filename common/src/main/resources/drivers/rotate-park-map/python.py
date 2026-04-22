{USER_CODE}

import json
matrix = json.loads(input())
Solution().rotateParkMap(matrix)
print(json.dumps(matrix, separators=(',', ':')))
