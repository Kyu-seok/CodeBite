{USER_CODE}

nums = eval(input())
# The solution gets a copy: one that edits the array must not change what is checked.
result = Solution().pinpointPeak(list(nums))


# Defined after the call, so it can't replace a global of the same name the solution uses.
def _is_returned_peak(readings, i):
    n = len(readings)
    if type(i) is not int or not 0 <= i < n:
        return False
    return (i == 0 or readings[i] > readings[i - 1]) and (i == n - 1 or readings[i] > readings[i + 1])


print("VALID" if _is_returned_peak(nums, result) else f"INVALID:{result}")
