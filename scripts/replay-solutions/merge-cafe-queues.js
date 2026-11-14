class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class Solution {
    mergeCafeQueues(queues) {
        const nodes = [];
        for (let q of queues) {
            for (; q; q = q.next) nodes.push(q);
        }
        nodes.sort((a, b) => a.val - b.val);
        const dummy = new ListNode(0);
        let tail = dummy;
        for (const node of nodes) {
            tail.next = node;
            tail = node;
        }
        tail.next = null;
        return dummy.next;
    }
}
