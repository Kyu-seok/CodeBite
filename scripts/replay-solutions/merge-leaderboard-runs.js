class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class Solution {
    mergeRuns(runA, runB) {
        const dummy = new ListNode(0);
        let tail = dummy;
        while (runA && runB) {
            if (runA.val <= runB.val) {
                tail.next = runA;
                runA = runA.next;
            } else {
                tail.next = runB;
                runB = runB.next;
            }
            tail = tail.next;
        }
        tail.next = runA || runB;
        return dummy.next;
    }
}
