{USER_CODE}

import json
combo = eval(input())
k = int(input())
result = Solution().peakComboPerWindow(combo, k)
print(json.dumps(result, separators=(',', ':')))
