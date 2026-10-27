class Solution:
    def longestSeatBlock(self, seatIds: list[int]) -> int:
        seats = set(seatIds)
        longest = 0
        for seat in seats:
            if seat - 1 in seats:
                continue
            end = seat
            while end + 1 in seats:
                end += 1
            longest = max(longest, end - seat + 1)
        return longest
