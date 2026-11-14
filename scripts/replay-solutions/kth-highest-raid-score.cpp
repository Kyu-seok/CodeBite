#include <queue>
#include <functional>

class Solution {
public:
    int kthHighestScore(vector<int>& scores, int k) {
        // A min-heap of the k highest scores seen so far: its top is the k-th highest.
        priority_queue<int, vector<int>, greater<int>> top;
        for (int score : scores) {
            top.push(score);
            if ((int) top.size() > k) top.pop();
        }
        return top.top();
    }
};
