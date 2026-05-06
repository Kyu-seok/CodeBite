{USER_CODE}

import json
strs = json.loads(input())
result = Solution().groupAnagrams(strs)
result = [sorted(group) for group in result]
result.sort()
print(json.dumps(result, separators=(',', ':')))
