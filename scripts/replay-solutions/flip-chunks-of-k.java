class Solution {
    public ListNode flipChunks(ListNode head, int k) {
        ListNode dummy = new ListNode(0, head);
        ListNode before = dummy;
        while (true) {
            ListNode end = before;
            for (int i = 0; i < k; i++) {
                end = end.next;
                if (end == null) return dummy.next;
            }
            ListNode first = before.next, after = end.next;
            ListNode prev = after, node = first;
            while (node != after) {
                ListNode next = node.next;
                node.next = prev;
                prev = node;
                node = next;
            }
            before.next = end;
            before = first;
        }
    }
}
