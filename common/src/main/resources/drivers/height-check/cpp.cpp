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
    bool result = Solution().isBalanced(root);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
