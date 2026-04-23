#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

// {{LIB:TreeNode}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    TreeNode* root = treeFromArray(line);
    Solution().unrollSchedule(root);
    cout << "[";
    TreeNode* curr = root;
    bool first = true;
    while (curr != nullptr) {
        if (!first) cout << ",";
        cout << curr->val;
        first = false;
        curr = curr->right;
    }
    cout << "]" << endl;
    return 0;
}
