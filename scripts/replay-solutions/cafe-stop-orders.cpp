class Solution {
public:
    vector<vector<int>> listStationOrders(vector<int>& stops) {
        sort(stops.begin(), stops.end());
        vector<vector<int>> out;
        do {
            out.push_back(stops);
        } while (next_permutation(stops.begin(), stops.end()));
        return out;
    }
};
