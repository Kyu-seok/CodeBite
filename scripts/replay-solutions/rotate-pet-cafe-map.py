class Solution:
    def rotateParkMap(self, cafeMap: list[list[int]]) -> None:
        # Rotate 90 degrees clockwise in place: transpose, then reverse each row.
        n = len(cafeMap)
        for i in range(n):
            for j in range(i + 1, n):
                cafeMap[i][j], cafeMap[j][i] = cafeMap[j][i], cafeMap[i][j]
        for row in cafeMap:
            row.reverse()
