class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class Solution {
    dropTailBooking(head, n) {
        const dummy = new ListNode(0, head);
        let lead = dummy, trail = dummy;
        for (let i = 0; i < n; i++) lead = lead.next;
        while (lead.next) {
            lead = lead.next;
            trail = trail.next;
        }
        trail.next = trail.next.next;
        return dummy.next;
    }
}
