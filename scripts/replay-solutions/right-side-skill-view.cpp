#include <vector>
using namespace std;

class Solution {
public:
    vector<int> rightSideView(TreeNode* root) {
        vector<int> view;
        vector<TreeNode*> level;
        if (root) level.push_back(root);
        while (!level.empty()) {
            view.push_back(level.back()->val);
            vector<TreeNode*> next;
            for (TreeNode* node : level) {
                if (node->left) next.push_back(node->left);
                if (node->right) next.push_back(node->right);
            }
            level = next;
        }
        return view;
    }
};
