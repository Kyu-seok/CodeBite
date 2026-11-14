{USER_CODE}

import json
board = json.loads(input())
Solution().zeroOutRowsAndCols(board)
print(json.dumps(board, separators=(',', ':')))
