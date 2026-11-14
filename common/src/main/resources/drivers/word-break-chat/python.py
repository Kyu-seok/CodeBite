{USER_CODE}

import json
message = input().strip()
words = json.loads(input())
print(str(Solution().canSplitMessage(message, words)).lower())
