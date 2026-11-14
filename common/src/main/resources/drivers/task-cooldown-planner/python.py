{USER_CODE}

import json
jobs = json.loads(input())
n = int(input())
result = Solution().minPrintSlots(jobs, n)
print(result)
