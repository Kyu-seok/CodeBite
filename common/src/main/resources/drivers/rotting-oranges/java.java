import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();

        line = line.substring(1, line.length() - 1);
        List<int[]> rows = new ArrayList<>();
        int depth = 0;
        int start = 0;
        for (int i = 0; i < line.length(); i++) {
            if (line.charAt(i) == '[') { depth++; start = i; }
            else if (line.charAt(i) == ']') {
                depth--;
                if (depth == 0) {
                    String rowStr = line.substring(start + 1, i);
                    String[] parts = rowStr.split(",");
                    int[] row = new int[parts.length];
                    for (int j = 0; j < parts.length; j++) row[j] = Integer.parseInt(parts[j].trim());
                    rows.add(row);
                }
            }
        }
        int[][] grid = rows.toArray(new int[0][]);
        int result = new Solution().orangesRotting(grid);
        System.out.println(result);
    }
}
