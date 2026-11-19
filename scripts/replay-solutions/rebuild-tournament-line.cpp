#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<vector<int>> rebuildLine(vector<vector<int>>& players) {
        vector<vector<int>> sorted = players;
        sort(sorted.begin(), sorted.end(), [](const vector<int>& a, const vector<int>& b) {
            return a[0] != b[0] ? a[0] > b[0] : a[1] < b[1];
        });
        vector<vector<int>> line;
        for (size_t i = 0; i < sorted.size(); i++) line.insert(line.begin() + sorted[i][1], sorted[i]);
        return line;
    }
};
