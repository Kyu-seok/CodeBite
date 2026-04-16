{USER_CODE}

import json
words = json.loads(input())
k = int(input())
result = Solution().frequentWords(words, k)
print(json.dumps(result, separators=(',', ':')))
