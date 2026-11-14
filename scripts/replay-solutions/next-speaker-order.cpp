class Solution {
public:
    void nextLineup(vector<int>& lineup) {
        int i = (int)lineup.size() - 2;
        while (i >= 0 && lineup[i] >= lineup[i + 1]) i--;
        if (i >= 0) {
            int j = (int)lineup.size() - 1;
            while (lineup[j] <= lineup[i]) j--;
            swap(lineup[i], lineup[j]);
        }
        for (int a = i + 1, b = (int)lineup.size() - 1; a < b; a++, b--) swap(lineup[a], lineup[b]);
    }
};
