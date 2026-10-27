class Solution:
    def largestRectangleArea(self, heights: list[int]) -> int:
        best = 0
        stack: list[int] = []
        for i, height in enumerate(heights + [0]):
            while stack and heights[stack[-1]] >= height:
                top = heights[stack.pop()]
                left = stack[-1] + 1 if stack else 0
                best = max(best, top * (i - left))
            stack.append(i)
        return best
