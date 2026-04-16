{USER_CODE}

import json
jobs = json.loads(input())
n = int(input())
result = Solution().scheduleJobs(jobs, n)
print(result)
