class Solution {
public:
    bool canFinishAllTasks(int numTasks, vector<vector<int>>& prereqs) {
        vector<vector<int>> unlocks(numTasks);
        vector<int> waiting(numTasks, 0);
        for (auto& p : prereqs) {
            unlocks[p[1]].push_back(p[0]);
            waiting[p[0]]++;
        }
        vector<int> ready;
        for (int i = 0; i < numTasks; i++) if (waiting[i] == 0) ready.push_back(i);
        int done = 0;
        while (!ready.empty()) {
            int task = ready.back();
            ready.pop_back();
            done++;
            for (int next : unlocks[task]) {
                if (--waiting[next] == 0) ready.push_back(next);
            }
        }
        return done == numTasks;
    }
};
