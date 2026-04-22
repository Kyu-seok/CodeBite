{USER_CODE}

import json
board = json.loads(input())
result = Solution().verifySpeciesGrid(board)
print(str(result).lower())
