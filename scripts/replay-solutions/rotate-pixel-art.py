class Solution:
    def rotateImage(self, image: list[list[int]]) -> None:
        # Rotate 90 degrees clockwise in place: transpose, then reverse each row.
        n = len(image)
        for i in range(n):
            for j in range(i + 1, n):
                image[i][j], image[j][i] = image[j][i], image[i][j]
        for row in image:
            row.reverse()
