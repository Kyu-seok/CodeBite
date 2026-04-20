{USER_CODE}

def _safe_input():
    try:
        return input()
    except EOFError:
        return ''

s1 = _safe_input()
s2 = _safe_input()
s3 = _safe_input()
result = Solution().isWeave(s1, s2, s3)
print(str(result).lower())
