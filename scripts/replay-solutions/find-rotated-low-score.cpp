#include <vector>
using namespace std;

class Solution {
public:
    int findLowestScore(vector<int>& scores) {
        int low = 0, high = (int)scores.size() - 1;
        while (low < high) {
            int mid = (low + high) / 2;
            if (scores[mid] > scores[high]) low = mid + 1;
            else high = mid;
        }
        return scores[low];
    }
};
