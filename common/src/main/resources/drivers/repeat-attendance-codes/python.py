{USER_CODE}

import json
codes = eval(input())
result = Solution().listRepeatedCodes(codes)
result.sort()
print(json.dumps(result, separators=(',', ':')))
