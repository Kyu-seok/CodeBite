#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<vector<int>> zigzagRows(TreeNode* root) {
        vector<vector<int>> rows;
        vector<TreeNode*> level;
        if (root) level.push_back(root);
        bool leftToRight = true;
        while (!level.empty()) {
            vector<int> row;
            vector<TreeNode*> next;
            for (TreeNode* node : level) {
                row.push_back(node->val);
                if (node->left) next.push_back(node->left);
                if (node->right) next.push_back(node->right);
            }
            if (!leftToRight) reverse(row.begin(), row.end());
            rows.push_back(row);
            leftToRight = !leftToRight;
            level = next;
        }
        return rows;
    }
};
