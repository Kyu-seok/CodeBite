#include <vector>
#include <queue>

class Solution {
public:
    int crushHeaviestBlocks(vector<int>& blocks) {
        priority_queue<int> pile(blocks.begin(), blocks.end());
        while (pile.size() > 1) {
            int y = pile.top(); pile.pop();
            int x = pile.top(); pile.pop();
            if (y != x) pile.push(y - x);
        }
        return pile.empty() ? 0 : pile.top();
    }
};
