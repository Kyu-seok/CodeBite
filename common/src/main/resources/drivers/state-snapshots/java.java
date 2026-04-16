import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String opsLine = sc.nextLine().trim();
        String argsLine = sc.nextLine().trim();

        // Parse operations: ["SnapshotArray","set",...]
        List<String> ops = new ArrayList<>();
        for (String s : opsLine.substring(1, opsLine.length() - 1).split(",")) {
            ops.add(s.trim().replaceAll("\"", ""));
        }

        // Parse args: [[3],[0,5],[],[0,6],[0,0]]
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
        SnapshotArray snapArr = null;
        for (int idx = 0; idx < ops.size(); idx++) {
            if (idx > 0) sb.append(",");
            String op = ops.get(idx);
            int[] opArgs = argsList.get(idx);
            switch (op) {
                case "SnapshotArray":
                    snapArr = new SnapshotArray(opArgs[0]);
                    sb.append("null");
                    break;
                case "set":
                    snapArr.set(opArgs[0], opArgs[1]);
                    sb.append("null");
                    break;
                case "snap":
                    sb.append(snapArr.snap());
                    break;
                case "get":
                    sb.append(snapArr.get(opArgs[0], opArgs[1]));
                    break;
            }
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
