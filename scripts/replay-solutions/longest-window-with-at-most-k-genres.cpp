class Solution {
public:
    int longestKGenreWindow(string queue, int k) {
        if (k == 0) return 0;
        vector<int> count(26, 0); // tags of each genre in the window queue[left..right]
        int genres = 0, best = 0, left = 0;
        for (int right = 0; right < (int) queue.size(); right++) {
            if (count[queue[right] - 'a']++ == 0) genres++;
            while (genres > k) {
                if (--count[queue[left] - 'a'] == 0) genres--;
                left++;
            }
            best = max(best, right - left + 1);
        }
        return best;
    }
};
