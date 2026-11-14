class Solution {
    public int countLongestIncreasing(int[] nums) {
        int n = nums.length;
        int[] length = new int[n]; // longest increasing subsequence ending at i
        int[] count = new int[n];  // how many subsequences reach that length
        int longest = 0;
        for (int i = 0; i < n; i++) {
            length[i] = 1;
            count[i] = 1;
            for (int j = 0; j < i; j++) {
                if (nums[j] < nums[i]) {
                    if (length[j] + 1 > length[i]) {
                        length[i] = length[j] + 1;
                        count[i] = count[j];
                    } else if (length[j] + 1 == length[i]) {
                        count[i] += count[j];
                    }
                }
            }
            longest = Math.max(longest, length[i]);
        }
        int total = 0;
        for (int i = 0; i < n; i++) if (length[i] == longest) total += count[i];
        return total;
    }
}
