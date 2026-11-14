class Node {
    constructor(val = 0, next = null, related = null) {
        this.val = val;
        this.next = next;
        this.related = related;
    }
}

class Solution {
    cloneQuestLog(head) {
        const copies = new Map();
        for (let node = head; node; node = node.next) copies.set(node, new Node(node.val));
        for (const [original, copy] of copies) {
            copy.next = original.next ? copies.get(original.next) : null;
            copy.related = original.related ? copies.get(original.related) : null;
        }
        return head ? copies.get(head) : null;
    }
}
