#include <string>
#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    string spaceBakes(string cookies) {
        int n = cookies.size();
        vector<int> counts(26, 0);
        for (char c : cookies) counts[c - 'a']++;
        vector<int> kinds(26);
        for (int i = 0; i < 26; i++) kinds[i] = i;
        sort(kinds.begin(), kinds.end(), [&](int a, int b) {
            return counts[a] != counts[b] ? counts[a] > counts[b] : a < b;
        });
        if (counts[kinds[0]] > (n + 1) / 2) return "";
        string result(n, ' ');
        int slot = 0;
        for (int kind : kinds) {
            for (int k = 0; k < counts[kind]; k++) {
                if (slot >= n) slot = 1;
                result[slot] = 'a' + kind;
                slot += 2;
            }
        }
        return result;
    }
};
