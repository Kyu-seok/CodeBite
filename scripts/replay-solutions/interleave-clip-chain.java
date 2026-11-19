class Solution {
    public void interleaveClips(ListNode head) {
        java.util.List<ListNode> nodes = new java.util.ArrayList<>();
        for (ListNode node = head; node != null; node = node.next) nodes.add(node);
        int i = 0, j = nodes.size() - 1;
        ListNode tail = null;
        while (i <= j) {
            ListNode front = nodes.get(i++);
            if (tail != null) tail.next = front;
            tail = front;
            if (i - 1 == j) break;
            ListNode back = nodes.get(j--);
            tail.next = back;
            tail = back;
        }
        tail.next = null;
    }
}
