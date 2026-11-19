#include <climits>
using namespace std;

class Solution {
public:
    bool isValidBST(TreeNode* root) {
        return check(root, LLONG_MIN, LLONG_MAX);
    }

private:
    bool check(TreeNode* node, long long low, long long high) {
        if (node == nullptr) return true;
        if (node->val <= low || node->val >= high) return false;
        return check(node->left, low, node->val) && check(node->right, node->val, high);
    }
};
