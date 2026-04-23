#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

// {{LIB:TreeNode}}
// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    TreeNode* root = treeFromArray(line);
    vector<vector<int>> result = Solution().alternateWardSweep(root);
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
