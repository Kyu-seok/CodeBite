#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
#include <algorithm>
using namespace std;

// {{LIB:TreeNode}}
// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    string targetStr;
    getline(cin, targetStr);
    int target = stoi(targetStr);
    TreeNode* root = treeFromArray(line);
    vector<vector<int>> result = Solution().targetPath(root, target);
    sort(result.begin(), result.end());
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
