class ListNode {
    int val;
    ListNode next;
    ListNode() {}
    ListNode(int val) { this.val = val; }
    ListNode(int val, ListNode next) { this.val = val; this.next = next; }

    static ListNode fromArray(String input) {
        input = input.trim();
        if (input.equals("[]")) return null;
        String inner = input.substring(1, input.length() - 1);
        String[] parts = inner.split(",");
        ListNode dummy = new ListNode(0);
        ListNode curr = dummy;
        for (String p : parts) {
            curr.next = new ListNode(Integer.parseInt(p.trim()));
            curr = curr.next;
        }
        return dummy.next;
    }

    static String toJsonArray(ListNode head) {
        if (head == null) return "[]";
        StringBuilder sb = new StringBuilder("[");
        ListNode curr = head;
        boolean first = true;
        while (curr != null) {
            if (!first) sb.append(",");
            first = false;
            sb.append(curr.val);
            curr = curr.next;
        }
        sb.append("]");
        return sb.toString();
    }
}
