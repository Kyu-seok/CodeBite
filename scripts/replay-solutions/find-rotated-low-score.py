class Solution:
    def locateTerminus(self, scores: list[int]) -> int:
        low, high = 0, len(scores) - 1
        while low < high:
            mid = (low + high) // 2
            if scores[mid] > scores[high]:
                low = mid + 1
            else:
                high = mid
        return scores[low]
