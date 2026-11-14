class Solution {
    public ListNode mergeCafeQueues(ListNode[] queues) {
        PriorityQueue<ListNode> heads = new PriorityQueue<>((a, b) -> Integer.compare(a.val, b.val));
        for (ListNode q : queues) if (q != null) heads.add(q);
        ListNode dummy = new ListNode(0), tail = dummy;
        while (!heads.isEmpty()) {
            ListNode node = heads.poll();
            tail.next = node;
            tail = node;
            if (node.next != null) heads.add(node.next);
        }
        tail.next = null;
        return dummy.next;
    }
}
