class Solution {
public:
    ListNode* mergeRuns(ListNode* runA, ListNode* runB) {
        ListNode dummy(0);
        ListNode* tail = &dummy;
        while (runA && runB) {
            if (runA->val <= runB->val) {
                tail->next = runA;
                runA = runA->next;
            } else {
                tail->next = runB;
                runB = runB->next;
            }
            tail = tail->next;
        }
        tail->next = runA ? runA : runB;
        return dummy.next;
    }
};
