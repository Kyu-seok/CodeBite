{USER_CODE}

import json

try:
    digits = input().strip()
except EOFError:
    digits = ''
result = sorted(Solution().letterCombinations(digits))
print(json.dumps(result, separators=(',', ':')))
