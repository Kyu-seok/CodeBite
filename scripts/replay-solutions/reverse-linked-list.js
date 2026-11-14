class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class Solution {
    reverseList(head) {
        let previous = null;
        while (head) {
            const next = head.next;
            head.next = previous;
            previous = head;
            head = next;
        }
        return previous;
    }
}
