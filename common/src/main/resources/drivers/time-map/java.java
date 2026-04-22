import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String opsLine = sc.nextLine().trim();
        String argsLine = sc.nextLine().trim();

        // Parse operations: ["TimestampedStore","write","readAt",...]
        List<String> ops = new ArrayList<>();
        for (String s : opsLine.substring(1, opsLine.length() - 1).split(",")) {
            ops.add(s.trim().replace("\"", ""));
        }

        // Parse args: [[],["foo","bar",1],["foo",1],...]
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

        TimestampedStore obj = null;
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < ops.size(); i++) {
            if (i > 0) sb.append(",");
            String op = ops.readAt(i);
            String raw = rawArgs.readAt(i);

            if (op.equals("TimestampedStore")) {
                obj = new TimestampedStore();
                sb.append("null");
            } else if (op.equals("write")) {
                // Parse "foo","bar",1
                String[] parts = splitArgs(raw);
                String key = parts[0].replace("\"", "");
                String value = parts[1].replace("\"", "");
                int timestamp = Integer.parseInt(parts[2].trim());
                obj.write(key, value, timestamp);
                sb.append("null");
            } else if (op.equals("readAt")) {
                // Parse "foo",1
                String[] parts = splitArgs(raw);
                String key = parts[0].replace("\"", "");
                int timestamp = Integer.parseInt(parts[1].trim());
                String result = obj.readAt(key, timestamp);
                sb.append("\"").append(result).append("\"");
            }
        }
        sb.append("]");
        System.out.println(sb.toString());
    }

    private static String[] splitArgs(String raw) {
        List<String> parts = new ArrayList<>();
        boolean inQuote = false;
        int start = 0;
        for (int i = 0; i < raw.length(); i++) {
            if (raw.charAt(i) == '"') inQuote = !inQuote;
            else if (raw.charAt(i) == ',' && !inQuote) {
                parts.add(raw.substring(start, i).trim());
                start = i + 1;
            }
        }
        parts.add(raw.substring(start).trim());
        return parts.toArray(new String[0]);
    }
}
