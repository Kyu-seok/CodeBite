#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int maxSnackHaul(vector<int>& snacks) {
        int skipped = 0, taken = 0;
        for (int haul : snacks) {
            int nextTaken = skipped + haul;
            skipped = max(skipped, taken);
            taken = nextTaken;
        }
        return max(skipped, taken);
    }
};
