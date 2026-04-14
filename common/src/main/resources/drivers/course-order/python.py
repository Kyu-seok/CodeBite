{USER_CODE}

import json

num_courses = int(input())
prerequisites = json.loads(input())
result = Solution().find_order(num_courses, prerequisites)
print(json.dumps(result, separators=(',', ':')))
