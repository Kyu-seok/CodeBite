class Solution {
    public int longestRisingScores(int[] scores) {
        // tails[k] is the smallest score that ends a strictly increasing subsequence of length k + 1.
        int[] tails = new int[scores.length];
        int size = 0;
        for (int score : scores) {
            int lo = 0, hi = size;
            while (lo < hi) {
                int mid = (lo + hi) / 2;
                if (tails[mid] < score) lo = mid + 1; else hi = mid;
            }
            tails[lo] = score;
            if (lo == size) size++;
        }
        return size;
    }
}
