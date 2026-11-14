class Solution {
    rotateImage(image) {
        const n = image.length;
        for (let i = 0; i < n; i++) {
            for (let j = i + 1; j < n; j++) {
                const t = image[i][j];
                image[i][j] = image[j][i];
                image[j][i] = t;
            }
        }
        for (const row of image) row.reverse();
    }
}
