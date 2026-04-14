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
    vector<int> result = Solution().rightSideView(root);
    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << result[i];
    }
    cout << "]" << endl;
    return 0;
}
