class Solution {
public:
    void flattenAgenda(TreeNode* root) {
        TreeNode* node = root;
        while (node != nullptr) {
            if (node->left != nullptr) {
                TreeNode* tail = node->left;
                while (tail->right != nullptr) tail = tail->right;
                tail->right = node->right;
                node->right = node->left;
                node->left = nullptr;
            }
            node = node->right;
        }
    }
};
