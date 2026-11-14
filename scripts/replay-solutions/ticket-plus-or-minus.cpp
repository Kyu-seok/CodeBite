#include <vector>
#include <map>
class Solution {
public:
    int countSignAssignments(vector<int>& tickets, int target) {
        map<int, int> ways;
        ways[0] = 1;
        for (int value : tickets) {
            map<int, int> following;
            for (auto& entry : ways) {
                following[entry.first + value] += entry.second;
                following[entry.first - value] += entry.second;
            }
            ways = following;
        }
        return ways.count(target) ? ways[target] : 0;
    }
};
