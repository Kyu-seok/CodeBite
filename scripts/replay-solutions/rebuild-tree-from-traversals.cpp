#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
    int next = 0;
    unordered_map<int, int> position;

    TreeNode* build(vector<int>& preorder, int low, int high) {
        if (low > high) return nullptr;
        TreeNode* node = new TreeNode(preorder[next++]);
        int middle = position[node->val];
        node->left = build(preorder, low, middle - 1);
        node->right = build(preorder, middle + 1, high);
        return node;
    }

public:
    TreeNode* rebuildTree(vector<int>& preorder, vector<int>& inorder) {
        for (int i = 0; i < (int)inorder.size(); i++) position[inorder[i]] = i;
        next = 0;
        return build(preorder, 0, (int)inorder.size() - 1);
    }
};
