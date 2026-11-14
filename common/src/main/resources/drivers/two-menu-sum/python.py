{USER_CODE}

import json
menuPrice = eval(input())
budget = int(input())
result = Solution().findMenuPair(menuPrice, budget)
print(json.dumps(result, separators=(',', ':')))
