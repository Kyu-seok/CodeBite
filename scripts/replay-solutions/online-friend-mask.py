class Solution:
    def countOnlineFriends(self, friendMask: int) -> int:
        return (friendMask & 0xFFFFFFFF).bit_count()
