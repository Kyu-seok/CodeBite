#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

// {{LIB:TreeNode}}

{USER_CODE}

TreeNode* findNode(TreeNode* root, int val) {
    if (root == nullptr) return nullptr;
    if (root->val == val) return root;
    TreeNode* left = findNode(root->left, val);
    if (left != nullptr) return left;
    return findNode(root->right, val);
}

int main() {
    string line, pLine, qLine;
    getline(cin, line);
    getline(cin, pLine);
    getline(cin, qLine);
    TreeNode* root = treeFromArray(line);
    int pVal = stoi(pLine);
    int qVal = stoi(qLine);
    TreeNode* p = findNode(root, pVal);
    TreeNode* q = findNode(root, qVal);
    TreeNode* result = Solution().lowestCommonAncestor(root, p, q);
    cout << result->val << endl;
    return 0;
}
