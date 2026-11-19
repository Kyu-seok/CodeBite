class Solution {
public:
    ListNode* dropTailBooking(ListNode* head, int n) {
        ListNode dummy(0, head);
        ListNode* lead = &dummy;
        ListNode* trail = &dummy;
        for (int i = 0; i < n; i++) lead = lead->next;
        while (lead->next) {
            lead = lead->next;
            trail = trail->next;
        }
        trail->next = trail->next->next;
        return dummy.next;
    }
};
