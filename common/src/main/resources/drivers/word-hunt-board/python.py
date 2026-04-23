{USER_CODE}

import json

board = json.loads(input())
word = input().strip()
result = Solution().traceZonePath(board, word)
print(json.dumps(result))
