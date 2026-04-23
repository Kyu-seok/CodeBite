import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [[0,30],[5,10],[15,20]]
        List<int[]> list = new ArrayList<>();
        int i = 0;
        while (i < line.length()) {
            if (line.charAt(i) == '[' && i > 0 && line.charAt(i - 1) != '[') {
                // This is a nested array, but let's use depth tracking
            }
            i++;
        }
        // Re-parse using depth tracking
        i = 0;
        int depth = 0;
        while (i < line.length()) {
            char c = line.charAt(i);
            if (c == '[') {
                depth++;
                if (depth == 2) {
                    int j = line.indexOf(']', i);
                    String sub = line.substring(i + 1, j);
                    if (!sub.isEmpty()) {
                        String[] parts = sub.split(",");
                        int[] pair = new int[parts.length];
                        for (int k = 0; k < parts.length; k++) pair[k] = Integer.parseInt(parts[k].trim());
                        list.add(pair);
                    }
                    i = j;
                    depth--;
                }
            } else if (c == ']') {
                depth--;
            }
            i++;
        }
        int[][] intervals = list.toArray(new int[0][]);
        boolean result = new Solution().verifyTableBookings(intervals);
        System.out.println(result);
    }
}
