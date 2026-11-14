#include <vector>
#include <utility>
#include <climits>
#include <algorithm>
using namespace std;

class Solution {
public:
    int countDominantHeroes(TreeNode* root) {
        int total = 0;
        vector<pair<TreeNode*, int>> stack;
        if (root) stack.push_back(make_pair(root, INT_MIN));
        while (!stack.empty()) {
            TreeNode* node = stack.back().first;
            int best = stack.back().second;
            stack.pop_back();
            if (node->val >= best) total++;
            int next = max(best, node->val);
            if (node->left) stack.push_back(make_pair(node->left, next));
            if (node->right) stack.push_back(make_pair(node->right, next));
        }
        return total;
    }
};
