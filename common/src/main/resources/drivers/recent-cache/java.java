import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String opsLine = sc.nextLine().trim();
        String argsLine = sc.nextLine().trim();

        // Parse operations: ["RecentCache","put","get",...]
        List<String> ops = new ArrayList<>();
        for (String s : opsLine.substring(1, opsLine.length() - 1).split(",")) {
            ops.add(s.trim().replace("\"", ""));
        }

        // Parse args: [[2],[1,10],[2,20],[1],...]
        List<int[]> argsList = new ArrayList<>();
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
                    String content = inner.substring(start + 1, i).trim();
                    if (content.isEmpty()) {
                        argsList.add(new int[0]);
                    } else {
                        String[] parts = content.split(",");
                        int[] nums = new int[parts.length];
                        for (int j = 0; j < parts.length; j++) {
                            nums[j] = Integer.parseInt(parts[j].trim());
                        }
                        argsList.add(nums);
                    }
                }
            }
        }

        RecentCache obj = null;
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < ops.size(); i++) {
            if (i > 0) sb.append(",");
            String op = ops.get(i);
            int[] arg = argsList.get(i);

            if (op.equals("RecentCache")) {
                obj = new RecentCache(arg[0]);
                sb.append("null");
            } else if (op.equals("put")) {
                obj.put(arg[0], arg[1]);
                sb.append("null");
            } else if (op.equals("get")) {
                sb.append(obj.get(arg[0]));
            }
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
