class Solution {
public:
    vector<int> findTaskOrder(int numTasks, vector<vector<int>>& prereqs) {
        vector<vector<int>> unlocks(numTasks);
        vector<int> waiting(numTasks, 0);
        for (const auto& p : prereqs) {
            unlocks[p[1]].push_back(p[0]);
            waiting[p[0]]++;
        }
        vector<int> order;
        for (int t = 0; t < numTasks; t++) if (waiting[t] == 0) order.push_back(t);
        for (size_t head = 0; head < order.size(); head++) {
            for (int next : unlocks[order[head]]) {
                if (--waiting[next] == 0) order.push_back(next);
            }
        }
        if ((int)order.size() != numTasks) return {};
        return order;
    }
};
