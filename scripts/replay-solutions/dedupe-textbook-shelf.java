class Solution {
    public int compactShelf(int[] books) {
        int k = 1;
        for (int i = 1; i < books.length; i++) {
            if (books[i] != books[k - 1]) books[k++] = books[i];
        }
        return k;
    }
}
