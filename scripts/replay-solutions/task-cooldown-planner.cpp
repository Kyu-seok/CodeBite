#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int minPrintSlots(vector<char>& jobs, int n) {
        int counts[26] = {0};
        for (char job : jobs) counts[job - 'A']++;
        int most = 0, tied = 0;
        for (int count : counts) {
            if (count > most) { most = count; tied = 1; }
            else if (count == most && count > 0) tied++;
        }
        return max((int) jobs.size(), (most - 1) * (n + 1) + tied);
    }
};
