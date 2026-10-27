class Solution:
    def countFlagMismatches(self, leftFlags: int, rightFlags: int) -> int:
        return (leftFlags ^ rightFlags).bit_count()
