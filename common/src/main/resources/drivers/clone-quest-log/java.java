import java.util.*;

class Node {
    int val;
    Node next;
    Node related;
    Node(int val) { this.val = val; this.next = null; this.related = null; }
}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();

        // Parse [[val,related_index], ...] format
        List<Node> nodes = new ArrayList<>();
        List<Integer> relatedIndexes = new ArrayList<>();

        if (line.equals("[]")) {
            System.out.println("[]");
            return;
        }

        // Remove outer brackets
        String inner = line.substring(1, line.length() - 1);
        // Split by "],[" after removing first [ and last ]
        List<int[]> pairs = new ArrayList<>();
        int depth = 0;
        int start = 0;
        for (int i = 0; i < inner.length(); i++) {
            if (inner.charAt(i) == '[') depth++;
            else if (inner.charAt(i) == ']') depth--;
            else if (inner.charAt(i) == ',' && depth == 0) {
                String pair = inner.substring(start, i).trim();
                pairs.add(parsePair(pair));
                start = i + 1;
            }
        }
        pairs.add(parsePair(inner.substring(start).trim()));

        for (int[] p : pairs) {
            nodes.add(new Node(p[0]));
            relatedIndexes.add(p[1]);
        }

        for (int i = 0; i < nodes.size() - 1; i++) {
            nodes.get(i).next = nodes.get(i + 1);
        }
        for (int i = 0; i < nodes.size(); i++) {
            if (relatedIndexes.get(i) >= 0) {
                nodes.get(i).related = nodes.get(relatedIndexes.get(i));
            }
        }

        Node result = new Solution().cloneQuestLog(nodes.get(0));

        // Build index map for output
        Map<Node, Integer> indexMap = new HashMap<>();
        Node curr = result;
        int idx = 0;
        while (curr != null) {
            indexMap.put(curr, idx++);
            curr = curr.next;
        }

        StringBuilder sb = new StringBuilder("[");
        curr = result;
        boolean first = true;
        while (curr != null) {
            if (!first) sb.append(",");
            sb.append("[").append(curr.val).append(",");
            if (curr.related != null) {
                sb.append(indexMap.get(curr.related));
            } else {
                sb.append("null");
            }
            sb.append("]");
            first = false;
            curr = curr.next;
        }
        sb.append("]");
        System.out.println(sb.toString());
    }

    private static int[] parsePair(String s) {
        // s is like "[7,null]" or "[13,0]"
        s = s.trim();
        if (s.startsWith("[")) s = s.substring(1);
        if (s.endsWith("]")) s = s.substring(0, s.length() - 1);
        String[] parts = s.split(",");
        int val = Integer.parseInt(parts[0].trim());
        int related = parts[1].trim().equals("null") ? -1 : Integer.parseInt(parts[1].trim());
        return new int[]{val, related};
    }
}
