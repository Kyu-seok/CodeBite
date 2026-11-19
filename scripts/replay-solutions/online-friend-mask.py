class Solution:
    def countOnlineFriends(self, friendMask: int) -> int:
        mask = friendMask & 0xFFFFFFFF  # Java and C++ pass the same 32 bits as a signed int
        count = 0
        while mask:
            mask &= mask - 1  # clears the lowest 1 bit
            count += 1
        return count
