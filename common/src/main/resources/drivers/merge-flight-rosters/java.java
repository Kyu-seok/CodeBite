import java.util.*;

// {{LIB:ListNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();

        // Parse 2D array [[1,4,5],[1,3,4],[2,6]] or [] or [[]]
        List<ListNode> lists = new ArrayList<>();
        if (!line.equals("[]")) {
            // Remove outer brackets
            String inner = line.substring(1, line.length() - 1);
            int depth = 0;
            int start = 0;
            for (int i = 0; i < inner.length(); i++) {
                if (inner.charAt(i) == '[') depth++;
                else if (inner.charAt(i) == ']') depth--;
                else if (inner.charAt(i) == ',' && depth == 0) {
                    lists.add(ListNode.fromArray(inner.substring(start, i).trim()));
                    start = i + 1;
                }
            }
            lists.add(ListNode.fromArray(inner.substring(start).trim()));
        }

        ListNode[] arr = lists.toArray(new ListNode[0]);
        ListNode result = new Solution().mergeFlightRosters(arr);
        System.out.println(ListNode.toJsonArray(result));
    }
}
