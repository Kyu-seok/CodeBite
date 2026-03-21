#include <string>
#include <sstream>
using namespace std;

struct ListNode {
    int val;
    ListNode* next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode* nxt) : val(x), next(nxt) {}
};

ListNode* listFromArray(const string& input) {
    if (input == "[]") return nullptr;
    string inner = input.substr(1, input.size() - 2);
    ListNode dummy(0);
    ListNode* curr = &dummy;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        curr->next = new ListNode(stoi(token));
        curr = curr->next;
    }
    return dummy.next;
}

string listToJsonArray(ListNode* head) {
    if (!head) return "[]";
    ostringstream os;
    os << "[";
    bool first = true;
    while (head) {
        if (!first) os << ",";
        first = false;
        os << head->val;
        head = head->next;
    }
    os << "]";
    return os.str();
}
