class Solution {
public:
    int sumNumbers(TreeNode* root) {
        return sum(root, 0);
    }

private:
    int sum(TreeNode* node, int number) {
        if (node == nullptr) return 0;
        number = number * 10 + node->val;
        if (node->left == nullptr && node->right == nullptr) return number;
        return sum(node->left, number) + sum(node->right, number);
    }
};
