#include <vector>
using namespace std;

class Solution {
public:
    void interleaveClips(ListNode* head) {
        vector<ListNode*> nodes;
        for (ListNode* node = head; node; node = node->next) nodes.push_back(node);
        int i = 0, j = (int)nodes.size() - 1;
        ListNode* tail = nullptr;
        while (i <= j) {
            ListNode* front = nodes[i++];
            if (tail) tail->next = front;
            tail = front;
            if (i - 1 == j) break;
            ListNode* back = nodes[j--];
            tail->next = back;
            tail = back;
        }
        tail->next = nullptr;
    }
};
