#include <vector>
#include <algorithm>
#include <climits>
using namespace std;

class Solution {
public:
    int minPellets(vector<vector<int>>& zones) {
        vector<vector<int>> sorted = zones;
        sort(sorted.begin(), sorted.end(), [](const vector<int>& a, const vector<int>& b) { return a[1] < b[1]; });
        int pellets = 0;
        long long lastDrop = LLONG_MIN;
        for (const vector<int>& zone : sorted) {
            if (zone[0] > lastDrop) {
                pellets++;
                lastDrop = zone[1];
            }
        }
        return pellets;
    }
};
