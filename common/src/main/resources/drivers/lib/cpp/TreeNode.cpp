#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode* l, TreeNode* r) : val(x), left(l), right(r) {}
};

TreeNode* treeFromArray(const string& input) {
    if (input == "[]") return nullptr;
    string inner = input.substr(1, input.size() - 2);
    vector<string> tokens;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        size_t start = token.find_first_not_of(' ');
        size_t end = token.find_last_not_of(' ');
        tokens.push_back(start == string::npos ? "" : token.substr(start, end - start + 1));
    }
    if (tokens.empty() || tokens[0] == "null") return nullptr;
    TreeNode* root = new TreeNode(stoi(tokens[0]));
    queue<TreeNode*> q;
    q.push(root);
    int i = 1;
    while (!q.empty() && i < (int)tokens.size()) {
        TreeNode* node = q.front();
        q.pop();
        if (i < (int)tokens.size() && tokens[i] != "null") {
            node->left = new TreeNode(stoi(tokens[i]));
            q.push(node->left);
        }
        i++;
        if (i < (int)tokens.size() && tokens[i] != "null") {
            node->right = new TreeNode(stoi(tokens[i]));
            q.push(node->right);
        }
        i++;
    }
    return root;
}

string treeToJsonArray(TreeNode* root) {
    if (!root) return "[]";
    vector<string> parts;
    queue<TreeNode*> q;
    q.push(root);
    while (!q.empty()) {
        TreeNode* node = q.front();
        q.pop();
        if (!node) {
            parts.push_back("null");
        } else {
            parts.push_back(to_string(node->val));
            q.push(node->left);
            q.push(node->right);
        }
    }
    while (!parts.empty() && parts.back() == "null") {
        parts.pop_back();
    }
    ostringstream os;
    os << "[";
    for (int i = 0; i < (int)parts.size(); i++) {
        if (i > 0) os << ",";
        os << parts[i];
    }
    os << "]";
    return os.str();
}
