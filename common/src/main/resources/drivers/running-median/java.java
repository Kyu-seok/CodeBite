import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String opsLine = sc.nextLine().trim();
        String argsLine = sc.nextLine().trim();

        // Parse operations: ["MedianTracker","addNum","findMedian",...]
        List<String> ops = new ArrayList<>();
        for (String s : opsLine.substring(1, opsLine.length() - 1).split(",")) {
            ops.add(s.trim().replace("\"", ""));
        }

        // Parse args: [[],[1],[],[2],[],...]
        List<String> rawArgs = new ArrayList<>();
        String inner = argsLine.substring(1, argsLine.length() - 1);
        int depth = 0;
        int start = -1;
        for (int i = 0; i < inner.length(); i++) {
            char c = inner.charAt(i);
            if (c == '[') {
                if (depth == 0) start = i;
                depth++;
            } else if (c == ']') {
                depth--;
                if (depth == 0) {
                    rawArgs.add(inner.substring(start + 1, i));
                }
            }
        }

        MedianTracker obj = null;
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < ops.size(); i++) {
            if (i > 0) sb.append(",");
            String op = ops.get(i);
            String raw = rawArgs.get(i).trim();

            if (op.equals("MedianTracker")) {
                obj = new MedianTracker();
                sb.append("null");
            } else if (op.equals("addNum")) {
                int num = Integer.parseInt(raw);
                obj.addNum(num);
                sb.append("null");
            } else if (op.equals("findMedian")) {
                double median = obj.findMedian();
                if (median == (long) median) {
                    sb.append(String.format("%.1f", median));
                } else {
                    String formatted = String.valueOf(median);
                    sb.append(formatted);
                }
            }
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
