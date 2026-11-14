class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}

class Solution {
    addScoreLists(score1, score2) {
        const dummy = new ListNode(0);
        let tail = dummy, carry = 0;
        while (score1 || score2 || carry) {
            let sum = carry;
            if (score1) { sum += score1.val; score1 = score1.next; }
            if (score2) { sum += score2.val; score2 = score2.next; }
            tail.next = new ListNode(sum % 10);
            tail = tail.next;
            carry = Math.floor(sum / 10);
        }
        return dummy.next;
    }
}
