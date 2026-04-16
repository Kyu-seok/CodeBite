#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
using namespace std;

class Node {
public:
    int val;
    Node* left;
    Node* right;
    Node* next;

    Node() : val(0), left(nullptr), right(nullptr), next(nullptr) {}
    Node(int _val) : val(_val), left(nullptr), right(nullptr), next(nullptr) {}
    Node(int _val, Node* _left, Node* _right, Node* _next)
        : val(_val), left(_left), right(_right), next(_next) {}
};

{USER_CODE}

Node* buildTree(const string& input) {
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
    Node* root = new Node(stoi(tokens[0]));
    queue<Node*> q;
    q.push(root);
    int i = 1;
    while (!q.empty() && i < (int)tokens.size()) {
        Node* node = q.front();
        q.pop();
        if (i < (int)tokens.size() && tokens[i] != "null") {
            node->left = new Node(stoi(tokens[i]));
            q.push(node->left);
        }
        i++;
        if (i < (int)tokens.size() && tokens[i] != "null") {
            node->right = new Node(stoi(tokens[i]));
            q.push(node->right);
        }
        i++;
    }
    return root;
}

string serialize(Node* root) {
    if (!root) return "[]";
    ostringstream os;
    os << "[";
    bool first = true;
    Node* levelStart = root;
    while (levelStart != nullptr) {
        Node* curr = levelStart;
        while (curr != nullptr) {
            if (!first) os << ",";
            first = false;
            os << curr->val;
            curr = curr->next;
        }
        os << ",#";
        levelStart = levelStart->left;
    }
    os << "]";
    return os.str();
}

int main() {
    string line;
    getline(cin, line);
    Node* root = buildTree(line);
    Node* result = Solution().connect(root);
    cout << serialize(result) << endl;
    return 0;
}
