{USER_CODE}

import json
s = input().strip()
word_dict = json.loads(input())
print(str(Solution().wordBreak(s, word_dict)).lower())
