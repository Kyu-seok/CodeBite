class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class Solution {
    hasPortalLoop(head) {
        let slow = head, fast = head;
        while (fast && fast.next) {
            slow = slow.next;
            fast = fast.next.next;
            if (slow === fast) return true;
        }
        return false;
    }
}
