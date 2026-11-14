{USER_CODE}

import json
pricesA = json.loads(input())
pricesB = json.loads(input())
result = Solution().mergedPriceMedian(pricesA, pricesB)
print(f"{result:.1f}")
