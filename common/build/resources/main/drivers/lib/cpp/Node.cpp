#include <string>
#include <sstream>
#include <vector>
#include <queue>
#include <map>
using namespace std;

struct Node {
    int val;
    vector<Node*> neighbors;
    Node() : val(0) {}
    Node(int x) : val(x) {}
    Node(int x, vector<Node*> nbrs) : val(x), neighbors(nbrs) {}
};

Node* graphFromAdjList(const string& input) {
    if (input == "[]") return nullptr;
    vector<vector<int>> adjList;
    int i = 1;
    while (i < (int)input.size() - 1) {
        if (input[i] == '[') {
            int j = input.find(']', i);
            string inner = input.substr(i + 1, j - i - 1);
            vector<int> nbrs;
            if (!inner.empty()) {
                stringstream ss(inner);
                string token;
                while (getline(ss, token, ',')) {
                    nbrs.push_back(stoi(token));
                }
            }
            adjList.push_back(nbrs);
            i = j + 1;
        } else {
            i++;
        }
    }
    int n = adjList.size();
    vector<Node*> nodes(n + 1);
    for (int k = 1; k <= n; k++) nodes[k] = new Node(k);
    for (int k = 0; k < n; k++) {
        for (int nbr : adjList[k]) {
            nodes[k + 1]->neighbors.push_back(nodes[nbr]);
        }
    }
    return nodes[1];
}

string graphToAdjListJson(Node* node) {
    if (!node) return "[]";
    map<int, Node*> visited;
    queue<Node*> q;
    q.push(node);
    visited[node->val] = node;
    while (!q.empty()) {
        Node* curr = q.front();
        q.pop();
        for (Node* nbr : curr->neighbors) {
            if (visited.find(nbr->val) == visited.end()) {
                visited[nbr->val] = nbr;
                q.push(nbr);
            }
        }
    }
    ostringstream os;
    os << "[";
    bool first = true;
    for (auto& [val, n] : visited) {
        if (!first) os << ",";
        first = false;
        os << "[";
        for (size_t j = 0; j < n->neighbors.size(); j++) {
            if (j > 0) os << ",";
            os << n->neighbors[j]->val;
        }
        os << "]";
    }
    os << "]";
    return os.str();
}
