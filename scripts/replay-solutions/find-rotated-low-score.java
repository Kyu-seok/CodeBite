class Solution {
    public int findLowestScore(int[] scores) {
        int low = 0, high = scores.length - 1;
        while (low < high) {
            int mid = (low + high) / 2;
            if (scores[mid] > scores[high]) low = mid + 1;
            else high = mid;
        }
        return scores[low];
    }
}
