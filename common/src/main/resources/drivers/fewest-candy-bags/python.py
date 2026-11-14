{USER_CODE}

import json
bagSizes = json.loads(input())
quota = int(input())
print(Solution().fewestBags(bagSizes, quota))
