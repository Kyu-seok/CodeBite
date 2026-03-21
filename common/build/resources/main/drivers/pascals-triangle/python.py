{USER_CODE}

import json
numRows = int(input())
result = Solution().generate(numRows)
print(json.dumps(result, separators=(',', ':')))
