#include <vector>
using namespace std;

class Solution {
public:
    int majorityVote(vector<int>& votes) {
        int candidate = votes[0], count = 0;
        for (int vote : votes) {
            if (count == 0) candidate = vote;
            count += vote == candidate ? 1 : -1;
        }
        return candidate;
    }
};
