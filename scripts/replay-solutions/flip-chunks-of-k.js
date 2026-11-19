class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class Solution {
    flipChunks(head, k) {
        const dummy = new ListNode(0, head);
        let before = dummy;
        while (true) {
            let end = before;
            for (let i = 0; i < k; i++) {
                end = end.next;
                if (end === null) return dummy.next;
            }
            const first = before.next, after = end.next;
            let prev = after, node = first;
            while (node !== after) {
                const next = node.next;
                node.next = prev;
                prev = node;
                node = next;
            }
            before.next = end;
            before = first;
        }
    }
}
