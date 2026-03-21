{USER_CODE}

import json, ast
s = [c for c in ast.literal_eval(input())]
Solution().reverseString(s)
print(json.dumps(s, separators=(',', ':')))
