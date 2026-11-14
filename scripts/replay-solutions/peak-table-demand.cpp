#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int minTables(vector<vector<int>>& visits) {
        vector<int> arrive, leave;
        for (auto& v : visits) { arrive.push_back(v[0]); leave.push_back(v[1]); }
        sort(arrive.begin(), arrive.end());
        sort(leave.begin(), leave.end());
        int seated = 0, most = 0, j = 0;
        for (int i = 0; i < (int)arrive.size(); i++) {
            while (leave[j] <= arrive[i]) { j++; seated--; }
            seated++;
            most = max(most, seated);
        }
        return most;
    }
};
