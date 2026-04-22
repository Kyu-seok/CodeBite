{USER_CODE}

import json
num_courses = int(input())
prerequisites = json.loads(input())
result = Solution().can_finish(num_courses, prerequisites)
print(str(result).lower())
