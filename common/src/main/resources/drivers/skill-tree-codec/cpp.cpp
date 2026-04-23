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
    TreeSerializer codec;
    string serialized = codec.pack(root);
    TreeNode* result = codec.unpack(serialized);
    cout << treeToJsonArray(result) << endl;
    return 0;
}
