#include <vector>
using namespace std;

class Solution {
public:
    void moveVoidsToEnd(vector<int>& scans) {
        size_t write = 0;
        for (size_t i = 0; i < scans.size(); i++) {
            if (scans[i] != 0) scans[write++] = scans[i];
        }
        while (write < scans.size()) scans[write++] = 0;
    }
};
