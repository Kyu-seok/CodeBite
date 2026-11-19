class Solution {
    public void nextLineup(int[] lineup) {
        int i = lineup.length - 2;
        while (i >= 0 && lineup[i] >= lineup[i + 1]) i--;
        if (i >= 0) {
            int j = lineup.length - 1;
            while (lineup[j] <= lineup[i]) j--;
            int t = lineup[i]; lineup[i] = lineup[j]; lineup[j] = t;
        }
        for (int a = i + 1, b = lineup.length - 1; a < b; a++, b--) {
            int t = lineup[a]; lineup[a] = lineup[b]; lineup[b] = t;
        }
    }
}
