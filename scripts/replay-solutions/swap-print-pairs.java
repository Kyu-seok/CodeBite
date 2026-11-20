class Solution {
    public ListNode swapQueuePartners(ListNode head) {
        ListNode dummy = new ListNode(0, head);
        ListNode before = dummy;
        while (before.next != null && before.next.next != null) {
            ListNode first = before.next, second = before.next.next;
            first.next = second.next;
            second.next = first;
            before.next = second;
            before = first;
        }
        return dummy.next;
    }
}
