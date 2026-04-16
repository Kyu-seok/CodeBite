{USER_CODE}

import json
board = json.loads(input())
Solution().capture(board)
print(json.dumps(board, separators=(',', ':')))
