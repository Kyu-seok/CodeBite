#include <string>
#include <algorithm>
using namespace std;

class Solution {
public:
    bool canBalance(string brackets) {
        // The number of unclosed openers can be anything in [low, high].
        int low = 0, high = 0;
        for (char ch : brackets) {
            if (ch == '(') { low++; high++; }
            else if (ch == ')') { low--; high--; }
            else { low--; high++; }
            if (high < 0) return false;
            low = max(low, 0);
        }
        return low == 0;
    }
};
