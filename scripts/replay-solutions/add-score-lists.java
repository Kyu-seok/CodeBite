class Solution {
    public ListNode addScoreLists(ListNode score1, ListNode score2) {
        ListNode dummy = new ListNode(0), tail = dummy;
        int carry = 0;
        while (score1 != null || score2 != null || carry != 0) {
            int sum = carry;
            if (score1 != null) { sum += score1.val; score1 = score1.next; }
            if (score2 != null) { sum += score2.val; score2 = score2.next; }
            tail.next = new ListNode(sum % 10);
            tail = tail.next;
            carry = sum / 10;
        }
        return dummy.next;
    }
}
