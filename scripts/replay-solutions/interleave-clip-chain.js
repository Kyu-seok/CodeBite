class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class Solution {
    interleaveClips(head) {
        const nodes = [];
        for (let node = head; node; node = node.next) nodes.push(node);
        let i = 0, j = nodes.length - 1, tail = null;
        while (i <= j) {
            const front = nodes[i++];
            if (tail) tail.next = front;
            tail = front;
            if (i - 1 === j) break;
            const back = nodes[j--];
            tail.next = back;
            tail = back;
        }
        tail.next = null;
    }
}
