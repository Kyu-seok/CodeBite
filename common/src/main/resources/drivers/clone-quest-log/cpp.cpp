#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <unordered_map>
using namespace std;

class Node {
public:
    int val;
    Node* next;
    Node* random;
    Node(int _val) : val(_val), next(nullptr), random(nullptr) {}
};

{USER_CODE}

int main() {
    string line;
    getline(cin, line);

    if (line == "[]") {
        cout << "[]" << endl;
        return 0;
    }

    // Parse [[val,rand], ...] format
    vector<pair<int,int>> pairs;
    int depth = 0;
    string curr;
    int val = 0;
    bool inPair = false;
    bool readingVal = true;
    string token;

    for (int i = 1; i < (int)line.size() - 1; i++) {
        char c = line[i];
        if (c == '[') {
            token = "";
            readingVal = true;
        } else if (c == ']') {
            int r = (token == "null") ? -1 : stoi(token);
            pairs.push_back({val, r});
        } else if (c == ',' && readingVal) {
            val = stoi(token);
            token = "";
            readingVal = false;
        } else if (c == ',' && !readingVal) {
            // between pairs
        } else {
            token += c;
        }
    }

    vector<Node*> nodes;
    for (auto& p : pairs) {
        nodes.push_back(new Node(p.first));
    }
    for (int i = 0; i < (int)nodes.size() - 1; i++) {
        nodes[i]->next = nodes[i + 1];
    }
    for (int i = 0; i < (int)nodes.size(); i++) {
        if (pairs[i].second >= 0) {
            nodes[i]->random = nodes[pairs[i].second];
        }
    }

    Node* result = Solution().duplicateTopicWeb(nodes[0]);

    unordered_map<Node*, int> indexMap;
    Node* c = result;
    int idx = 0;
    while (c) {
        indexMap[c] = idx++;
        c = c->next;
    }

    cout << "[";
    c = result;
    bool first = true;
    while (c) {
        if (!first) cout << ",";
        cout << "[" << c->val << ",";
        if (c->random) cout << indexMap[c->random];
        else cout << "null";
        cout << "]";
        first = false;
        c = c->next;
    }
    cout << "]" << endl;
    return 0;
}
