{USER_CODE}

from collections import Counter

s = input().strip()
result = Solution().orderRecipeBakes(s)
if not result:
    print("")
else:
    freq_ok = Counter(result) == Counter(s)
    no_adj = all(result[i] != result[i - 1] for i in range(1, len(result)))
    if freq_ok and no_adj:
        print("valid")
    else:
        print("INVALID:" + result)
