class Solution {
    public int[] peakComboPerWindow(int[] combo, int k) {
        int n = combo.length;
        int[] peaks = new int[n - k + 1];
        int[] window = new int[n];
        int head = 0, tail = 0;
        for (int i = 0; i < n; i++) {
            while (tail > head && combo[window[tail - 1]] <= combo[i]) tail--;
            window[tail++] = i;
            if (window[head] <= i - k) head++;
            if (i >= k - 1) peaks[i - k + 1] = combo[window[head]];
        }
        return peaks;
    }
}
