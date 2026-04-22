{USER_CODE}

import json
graph = json.loads(input())
result = Solution().splitIntoTwoShifts(graph)
print(str(result).lower())
