{USER_CODE}

import json
nums1 = json.loads(input())
nums2 = json.loads(input())
result = Solution().mergedZoneMedian(nums1, nums2)
print(f"{result:.1f}")
