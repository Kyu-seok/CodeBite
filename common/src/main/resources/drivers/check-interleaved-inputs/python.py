{USER_CODE}

def _safe_input():
    try:
        return input()
    except EOFError:
        return ''

controllerA = _safe_input()
controllerB = _safe_input()
merged = _safe_input()
result = Solution().isInterleaving(controllerA, controllerB, merged)
print(str(result).lower())
