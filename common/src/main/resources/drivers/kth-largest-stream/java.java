import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String opsLine = sc.nextLine().trim();
        String argsLine = sc.nextLine().trim();

        // Parse operations: ["KthLargest","add",...]
        List<String> ops = new ArrayList<>();
        for (String s : opsLine.substring(1, opsLine.length() - 1).split(",")) {
            ops.add(s.trim().replaceAll("\"", ""));
        }

        // Parse args: [[3,[4,5,8,2]],[3],[5],...]
        // First arg is [k, [nums...]], rest are [val]
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

        StringBuilder sb = new StringBuilder("[");
        KthLargest obj = null;
        for (int idx = 0; idx < ops.size(); idx++) {
            if (idx > 0) sb.append(",");
            String op = ops.get(idx);
            String raw = rawArgs.get(idx);
            if (op.equals("KthLargest")) {
                // Parse "3,[4,5,8,2]"
                int commaIdx = raw.indexOf(',');
                int k = Integer.parseInt(raw.substring(0, commaIdx).trim());
                String numsStr = raw.substring(commaIdx + 1).trim();
                String numsInner = numsStr.substring(1, numsStr.length() - 1);
                int[] nums;
                if (numsInner.isEmpty()) {
                    nums = new int[0];
                } else {
                    String[] parts = numsInner.split(",");
                    nums = new int[parts.length];
                    for (int j = 0; j < parts.length; j++) nums[j] = Integer.parseInt(parts[j].trim());
                }
                obj = new KthLargest(k, nums);
                sb.append("null");
            } else if (op.equals("add")) {
                int val = Integer.parseInt(raw.trim());
                sb.append(obj.add(val));
            }
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
