{USER_CODE}

import json
board = json.loads(input())
Solution().captureEnclosedTiles(board)
print(json.dumps(board, separators=(',', ':')))
