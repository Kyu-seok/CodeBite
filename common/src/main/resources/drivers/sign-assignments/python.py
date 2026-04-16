{USER_CODE}

import json
nums = json.loads(input())
target = int(input())
result = Solution().signAssignments(nums, target)
print(result)
