class Solution {
public:
    Node* connect(Node* root) {
        Node* leftmost = root;
        while (leftmost != nullptr && leftmost->left != nullptr) {
            for (Node* node = leftmost; node != nullptr; node = node->next) {
                node->left->next = node->right;
                if (node->next != nullptr) node->right->next = node->next->left;
            }
            leftmost = leftmost->left;
        }
        return root;
    }
};
