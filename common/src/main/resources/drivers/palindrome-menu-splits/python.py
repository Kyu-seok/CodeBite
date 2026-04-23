{USER_CODE}

import json
s = input().strip()
result = Solution().splitMirrorPhrases(s)
result.sort()
print(json.dumps(result, separators=(',', ':')))
