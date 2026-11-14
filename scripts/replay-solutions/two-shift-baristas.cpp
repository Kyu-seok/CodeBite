#include <vector>
using namespace std;

class Solution {
public:
    bool splitIntoTwoShifts(vector<vector<int>>& conflicts) {
        int n = conflicts.size();
        vector<int> shift(n, -1);
        for (int start = 0; start < n; start++) {
            if (shift[start] != -1) continue;
            shift[start] = 0;
            vector<int> stack(1, start);
            while (!stack.empty()) {
                int node = stack.back();
                stack.pop_back();
                for (int other : conflicts[node]) {
                    if (shift[other] == -1) {
                        shift[other] = 1 - shift[node];
                        stack.push_back(other);
                    } else if (shift[other] == shift[node]) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
};
