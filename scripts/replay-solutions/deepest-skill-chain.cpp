#include <algorithm>
using namespace std;

class Solution {
public:
    int maxSkillDepth(TreeNode* root) {
        if (root == nullptr) return 0;
        return 1 + max(maxSkillDepth(root->left), maxSkillDepth(root->right));
    }
};
