{USER_CODE}

import json

board = json.loads(input())
word = input().strip()
result = Solution().exist(board, word)
print(json.dumps(result))
