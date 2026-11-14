#include <string>
#include <sstream>
using namespace std;

class Codec {
    void write(TreeNode* node, string& out) {
        if (!node) { out += "#,"; return; }
        out += to_string(node->val) + ",";
        write(node->left, out);
        write(node->right, out);
    }

    TreeNode* read(stringstream& in) {
        string t;
        if (!getline(in, t, ',') || t == "#") return nullptr;
        TreeNode* node = new TreeNode(stoi(t));
        node->left = read(in);
        node->right = read(in);
        return node;
    }
public:
    string serialize(TreeNode* root) {
        string out;
        write(root, out);
        return out;
    }

    TreeNode* deserialize(string data) {
        stringstream in(data);
        return read(in);
    }
};
