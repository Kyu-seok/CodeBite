{USER_CODE}

import json
jobs = json.loads(input())
n = int(input())
result = Solution().planStationRuns(jobs, n)
print(result)
