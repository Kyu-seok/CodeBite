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
    Codec codec;
    string serialized = codec.serialize(root);
    TreeNode* result = codec.deserialize(serialized);
    cout << treeToJsonArray(result) << endl;
    return 0;
}
