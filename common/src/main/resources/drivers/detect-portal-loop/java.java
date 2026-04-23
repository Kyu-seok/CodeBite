import java.util.*;

// {{LIB:ListNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        int pos = Integer.parseInt(sc.nextLine().trim());

        // Parse array manually to get individual nodes
        List<ListNode> nodes = new ArrayList<>();
        if (!line.equals("[]")) {
            String inner = line.substring(1, line.length() - 1);
            String[] parts = inner.split(",");
            ListNode dummy = new ListNode(0);
            ListNode curr = dummy;
            for (String p : parts) {
                curr.next = new ListNode(Integer.parseInt(p.trim()));
                curr = curr.next;
                nodes.add(curr);
            }
        }

        ListNode head = nodes.isEmpty() ? null : nodes.get(0);
        if (pos >= 0 && !nodes.isEmpty()) {
            nodes.get(nodes.size() - 1).next = nodes.get(pos);
        }

        boolean result = new Solution().detectTransferLoop(head);
        System.out.println(result ? "true" : "false");
    }
}
