class Solution:
    def isInterleaving(self, controllerA: str, controllerB: str, merged: str) -> bool:
        if len(controllerA) + len(controllerB) != len(merged):
            return False
        # ok[j]: controllerA[:i] and controllerB[:j] interleave into merged[:i + j]
        ok = [True] * (len(controllerB) + 1)
        for j in range(1, len(controllerB) + 1):
            ok[j] = ok[j - 1] and controllerB[j - 1] == merged[j - 1]
        for i in range(1, len(controllerA) + 1):
            ok[0] = ok[0] and controllerA[i - 1] == merged[i - 1]
            for j in range(1, len(controllerB) + 1):
                letter = merged[i + j - 1]
                ok[j] = (ok[j] and controllerA[i - 1] == letter) or (ok[j - 1] and controllerB[j - 1] == letter)
        return ok[len(controllerB)]
