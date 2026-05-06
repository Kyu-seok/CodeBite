{USER_CODE}

import json
board = json.loads(input())
result = Solution().isValidSudoku(board)
print(str(result).lower())
