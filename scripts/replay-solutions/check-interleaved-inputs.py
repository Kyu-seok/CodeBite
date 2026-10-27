class Solution:
    def checkMergedQueue(self, s1: str, s2: str, s3: str) -> bool:
        if len(s1) + len(s2) != len(s3):
            return False
        # ok[j]: s1[:i] and s2[:j] interleave into s3[:i + j]
        ok = [True] * (len(s2) + 1)
        for j in range(1, len(s2) + 1):
            ok[j] = ok[j - 1] and s2[j - 1] == s3[j - 1]
        for i in range(1, len(s1) + 1):
            ok[0] = ok[0] and s1[i - 1] == s3[i - 1]
            for j in range(1, len(s2) + 1):
                merged = s3[i + j - 1]
                ok[j] = (ok[j] and s1[i - 1] == merged) or (ok[j - 1] and s2[j - 1] == merged)
        return ok[len(s2)]
