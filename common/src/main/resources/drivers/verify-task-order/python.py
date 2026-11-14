{USER_CODE}

import json
num_tasks = int(input())
prereqs = json.loads(input())
result = Solution().canFinishAllTasks(num_tasks, prereqs)
print(str(result).lower())
