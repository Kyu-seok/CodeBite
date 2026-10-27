from functools import cache


class Solution:
    def validatePartStream(self, s: str, p: str) -> bool:
        @cache
        def matches(i: int, j: int) -> bool:
            """Whether p[j:] matches all of s[i:]."""
            if j == len(p):
                return i == len(s)
            first = i < len(s) and p[j] in (s[i], ".")
            if j + 1 < len(p) and p[j + 1] == "*":
                return matches(i, j + 2) or (first and matches(i + 1, j))
            return first and matches(i + 1, j + 1)

        return matches(0, 0)
