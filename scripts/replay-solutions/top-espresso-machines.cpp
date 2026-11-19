#include <vector>
#include <unordered_map>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<int> busiestMachines(vector<int>& checkIns, int k) {
        unordered_map<int, int> counts;
        for (int machine : checkIns) counts[machine]++;
        vector<int> machines;
        for (auto& entry : counts) machines.push_back(entry.first);
        sort(machines.begin(), machines.end(), [&](int a, int b) { return counts[a] > counts[b]; });
        machines.resize(k);
        return machines;
    }
};
