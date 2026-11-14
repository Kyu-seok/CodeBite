import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String opsLine = sc.nextLine().trim();
        String argsLine = sc.nextLine().trim();

        // Parse operations: ["LowTrackStack","push",...]
        List<String> ops = new ArrayList<>();
        for (String s : opsLine.substring(1, opsLine.length() - 1).split(",")) {
            ops.add(s.trim().replaceAll("\"", ""));
        }

        // Parse args: [[],[-2],[0],...]
        List<int[]> argsList = new ArrayList<>();
        int i = 0;
        String inner = argsLine.substring(1, argsLine.length() - 1);
        while (i < inner.length()) {
            if (inner.charAt(i) == '[') {
                int j = inner.indexOf(']', i);
                String sub = inner.substring(i + 1, j);
                if (sub.isEmpty()) {
                    argsList.add(new int[0]);
                } else {
                    String[] parts = sub.split(",");
                    int[] arr = new int[parts.length];
                    for (int k = 0; k < parts.length; k++) arr[k] = Integer.parseInt(parts[k].trim());
                    argsList.add(arr);
                }
                i = j + 1;
            } else {
                i++;
            }
        }

        StringBuilder sb = new StringBuilder("[");
        LowTrackStack stack = null;
        for (int idx = 0; idx < ops.size(); idx++) {
            if (idx > 0) sb.append(",");
            String op = ops.get(idx);
            int[] opArgs = argsList.get(idx);
            switch (op) {
                case "LowTrackStack":
                    stack = new LowTrackStack();
                    sb.append("null");
                    break;
                case "push":
                    stack.push(opArgs[0]);
                    sb.append("null");
                    break;
                case "pop":
                    stack.pop();
                    sb.append("null");
                    break;
                case "top":
                    sb.append(stack.top());
                    break;
                case "getMin":
                    sb.append(stack.getMin());
                    break;
            }
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
