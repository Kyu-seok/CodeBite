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
    string kStr;
    getline(cin, kStr);
    int k = stoi(kStr);
    TreeNode* root = treeFromArray(line);
    int result = Solution().kthSmallest(root, k);
    cout << result << endl;
    return 0;
}
