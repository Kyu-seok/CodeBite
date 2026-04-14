#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

// {{LIB:TreeNode}}

{USER_CODE}

vector<int> parseArray(const string& line) {
    vector<int> result;
    string inner = line.substr(1, line.size() - 2);
    if (inner.empty()) return result;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        result.push_back(stoi(token));
    }
    return result;
}

int main() {
    string preLine, inLine;
    getline(cin, preLine);
    getline(cin, inLine);
    vector<int> preorder = parseArray(preLine);
    vector<int> inorder = parseArray(inLine);
    TreeNode* result = Solution().buildTree(preorder, inorder);
    cout << treeToJsonArray(result) << endl;
    return 0;
}
