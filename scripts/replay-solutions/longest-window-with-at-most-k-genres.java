class Solution {
    public int longestKGenreWindow(String queue, int k) {
        if (k == 0) return 0;
        int[] count = new int[26]; // tags of each genre in the window queue[left..right]
        int genres = 0, best = 0, left = 0;
        for (int right = 0; right < queue.length(); right++) {
            if (count[queue.charAt(right) - 'a']++ == 0) genres++;
            while (genres > k) {
                if (--count[queue.charAt(left) - 'a'] == 0) genres--;
                left++;
            }
            best = Math.max(best, right - left + 1);
        }
        return best;
    }
}
