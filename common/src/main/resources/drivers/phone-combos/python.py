{USER_CODE}

import json

digits = input().strip()
result = sorted(Solution().letter_combinations(digits))
print(json.dumps(result, separators=(',', ':')))
