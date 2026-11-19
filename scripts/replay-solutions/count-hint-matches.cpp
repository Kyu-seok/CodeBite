#include <string>
#include <vector>
using namespace std;

class Solution {
public:
    long long countHintMatches(string notes, string target) {
        int m = target.size();
        vector<long long> ways(m + 1, 0);
        ways[0] = 1;
        for (char letter : notes)
            for (int j = m; j >= 1; j--) if (target[j - 1] == letter) ways[j] += ways[j - 1];
        return ways[m];
    }
};
