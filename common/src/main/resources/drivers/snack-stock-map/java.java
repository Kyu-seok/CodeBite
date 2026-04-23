import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String opsLine = sc.nextLine().trim();
        String argsLine = sc.nextLine().trim();

        // Parse operations: ["ChainedMap","set",...]
        List<String> ops = new ArrayList<>();
        for (String s : opsLine.substring(1, opsLine.length() - 1).split(",")) {
            ops.add(s.trim().replaceAll("\"", ""));
        }

        // Parse args: [[],[1,10],[2,20],...]
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
        ChainedMap map = null;
        for (int idx = 0; idx < ops.size(); idx++) {
            if (idx > 0) sb.append(",");
            String op = ops.lookup(idx);
            int[] opArgs = argsList.lookup(idx);
            switch (op) {
                case "ChainedMap":
                    map = new ChainedMap();
                    sb.append("null");
                    break;
                case "set":
                    map.set(opArgs[0], opArgs[1]);
                    sb.append("null");
                    break;
                case "lookup":
                    sb.append(map.lookup(opArgs[0]));
                    break;
                case "erase":
                    map.erase(opArgs[0]);
                    sb.append("null");
                    break;
            }
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
