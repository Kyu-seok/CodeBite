{USER_CODE}

import json
intervals = json.loads(input())
queries = json.loads(input())
result = Solution().minInterval(intervals, queries)
print(json.dumps(result, separators=(',', ':')))
