#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

// {{LIB:TreeNode}}

{USER_CODE}

int main() {
    string line1, line2;
    getline(cin, line1);
    getline(cin, line2);
    TreeNode* root = treeFromArray(line1);
    TreeNode* subRoot = treeFromArray(line2);
    bool result = Solution().isSubtree(root, subRoot);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
