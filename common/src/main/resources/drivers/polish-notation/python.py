{USER_CODE}

import json
tokens = json.loads(input())
result = Solution().eval_rpn(tokens)
print(result)
