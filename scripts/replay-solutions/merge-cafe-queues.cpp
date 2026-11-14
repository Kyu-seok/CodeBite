#include <vector>
#include <queue>

class Solution {
public:
    ListNode* mergeCafeQueues(vector<ListNode*>& queues) {
        auto later = [](ListNode* a, ListNode* b) { return a->val > b->val; };
        priority_queue<ListNode*, vector<ListNode*>, decltype(later)> heads(later);
        for (ListNode* q : queues) if (q) heads.push(q);
        ListNode dummy(0);
        ListNode* tail = &dummy;
        while (!heads.empty()) {
            ListNode* node = heads.top(); heads.pop();
            tail->next = node;
            tail = node;
            if (node->next) heads.push(node->next);
        }
        tail->next = nullptr;
        return dummy.next;
    }
};
