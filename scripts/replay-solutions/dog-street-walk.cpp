#include <vector>
#include <string>
#include <map>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<string> planWalk(vector<vector<string>>& routes) {
        map<string, vector<string>> outgoing;
        for (auto& r : routes) outgoing[r[0]].push_back(r[1]);
        for (auto& entry : outgoing) sort(entry.second.rbegin(), entry.second.rend());
        vector<string> walk;
        vector<string> stack(1, "HUB");
        while (!stack.empty()) {
            vector<string>& next = outgoing[stack.back()];
            if (!next.empty()) {
                string to = next.back();
                next.pop_back();
                stack.push_back(to);
            } else {
                walk.push_back(stack.back());
                stack.pop_back();
            }
        }
        reverse(walk.begin(), walk.end());
        return walk;
    }
};
