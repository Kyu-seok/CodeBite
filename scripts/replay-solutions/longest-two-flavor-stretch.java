import java.util.HashMap;
import java.util.Map;

class Solution {
    public int longestTwoFlavorStretch(int[] treats) {
        Map<Integer, Integer> count = new HashMap<>(); // treats of each flavor in treats[left..right]
        int best = 0, left = 0;
        for (int right = 0; right < treats.length; right++) {
            count.merge(treats[right], 1, Integer::sum);
            while (count.size() > 2) {
                int out = treats[left++];
                if (count.merge(out, -1, Integer::sum) == 0) count.remove(out);
            }
            best = Math.max(best, right - left + 1);
        }
        return best;
    }
}
