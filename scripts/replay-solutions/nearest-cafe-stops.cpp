#include <vector>
#include <algorithm>

class Solution {
public:
    vector<vector<int>> selectNearestStops(vector<vector<int>>& stops, int k) {
        vector<vector<int>> sorted(stops);
        auto dist = [](const vector<int>& p) { return (long long) p[0] * p[0] + (long long) p[1] * p[1]; };
        sort(sorted.begin(), sorted.end(), [&](const vector<int>& a, const vector<int>& b) { return dist(a) < dist(b); });
        sorted.resize(k);
        return sorted;
    }
};
