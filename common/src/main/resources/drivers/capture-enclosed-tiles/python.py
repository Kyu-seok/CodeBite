{USER_CODE}

import json
board = json.loads(input())
Solution().seizeEnclosedZones(board)
print(json.dumps(board, separators=(',', ':')))
