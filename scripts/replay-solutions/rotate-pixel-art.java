class Solution {
    public void rotateImage(int[][] image) {
        int n = image.length;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int t = image[i][j];
                image[i][j] = image[j][i];
                image[j][i] = t;
            }
        }
        for (int[] row : image) {
            for (int a = 0, b = n - 1; a < b; a++, b--) {
                int t = row[a];
                row[a] = row[b];
                row[b] = t;
            }
        }
    }
}
