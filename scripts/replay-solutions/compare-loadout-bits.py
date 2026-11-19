class Solution:
    def countFlagMismatches(self, leftFlags: int, rightFlags: int) -> int:
        diff = leftFlags ^ rightFlags  # 1 exactly where the two differ
        count = 0
        while diff:
            diff &= diff - 1  # clears the lowest 1 bit
            count += 1
        return count
