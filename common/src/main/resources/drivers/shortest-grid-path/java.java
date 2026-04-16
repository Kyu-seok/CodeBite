import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [[0,1],[1,0]]
        List<int[]> rows = new ArrayList<>();
        int i = 0;
        while (i < line.length()) {
            if (line.charAt(i) == '[' && i > 0) {
                int j = line.indexOf(']', i);
                String sub = line.substring(i + 1, j);
                if (!sub.isEmpty()) {
                    String[] parts = sub.split(",");
                    int[] row = new int[parts.length];
                    for (int k = 0; k < parts.length; k++) row[k] = Integer.parseInt(parts[k].trim());
                    rows.add(row);
                }
                i = j + 1;
            } else {
                i++;
            }
        }
        int[][] grid = rows.toArray(new int[0][]);
        System.out.println(new Solution().shortestPath(grid));
    }
}
