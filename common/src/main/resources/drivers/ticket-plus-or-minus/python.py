{USER_CODE}

import json
nums = json.loads(input())
target = int(input())
result = Solution().partitionTankDoses(nums, target)
print(result)
