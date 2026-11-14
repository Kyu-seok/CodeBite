class Solution {
public:
    Node* cloneMap(Node* node) {
        if (!node) return nullptr;
        unordered_map<Node*, Node*> copies;
        copies[node] = new Node(node->val);
        vector<Node*> stack = {node};
        while (!stack.empty()) {
            Node* original = stack.back();
            stack.pop_back();
            for (Node* neighbor : original->neighbors) {
                if (!copies.count(neighbor)) {
                    copies[neighbor] = new Node(neighbor->val);
                    stack.push_back(neighbor);
                }
                copies[original]->neighbors.push_back(copies[neighbor]);
            }
        }
        return copies[node];
    }
};
