{USER_CODE}

import json

intervals = json.loads(input())
result = Solution().erase_overlap_intervals(intervals)
print(result)
