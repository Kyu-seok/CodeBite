class Solution {
public:
    Node* cloneQuestLog(Node* head) {
        unordered_map<Node*, Node*> copies;
        copies[nullptr] = nullptr;
        for (Node* node = head; node; node = node->next) copies[node] = new Node(node->val);
        for (Node* node = head; node; node = node->next) {
            copies[node]->next = copies[node->next];
            copies[node]->related = copies[node->related];
        }
        return copies[head];
    }
};
