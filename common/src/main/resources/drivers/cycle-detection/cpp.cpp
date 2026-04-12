#include <iostream>
#include <string>
#include <sstream>
#include <vector>
using namespace std;

// {{LIB:ListNode}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    string posStr;
    getline(cin, posStr);
    int pos = stoi(posStr);

    vector<ListNode*> nodes;
    if (line != "[]") {
        string inner = line.substr(1, line.size() - 2);
        stringstream ss(inner);
        string token;
        ListNode dummy(0);
        ListNode* curr = &dummy;
        while (getline(ss, token, ',')) {
            curr->next = new ListNode(stoi(token));
            curr = curr->next;
            nodes.push_back(curr);
        }
    }

    ListNode* head = nodes.empty() ? nullptr : nodes[0];
    if (pos >= 0 && !nodes.empty()) {
        nodes[nodes.size() - 1]->next = nodes[pos];
    }

    bool result = Solution().hasCycle(head);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
