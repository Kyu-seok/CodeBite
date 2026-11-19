#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int longestPathEdges(TreeNode* root) {
        best = 0;
        depth(root);
        return best;
    }

private:
    int best = 0;

    int depth(TreeNode* node) {
        if (!node) return 0;
        int left = depth(node->left);
        int right = depth(node->right);
        best = max(best, left + right);
        return 1 + max(left, right);
    }
};
