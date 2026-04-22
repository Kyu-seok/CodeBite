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
    TreeNode* p = treeFromArray(line1);
    TreeNode* q = treeFromArray(line2);
    bool result = Solution().matchCatalogLayout(p, q);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
