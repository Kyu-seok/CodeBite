{USER_CODE}

import json

board = json.loads(input())
words = json.loads(input())
result = sorted(Solution().flagMaterialCodes(board, words))
print(json.dumps(result, separators=(',', ':')))
