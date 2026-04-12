import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [["1","0"],["0","1"]]
        List<char[]> rows = new ArrayList<>();
        int i = 1; // skip outer [
        while (i < line.length() - 1) {
            if (line.charAt(i) == '[') {
                int j = line.indexOf(']', i);
                String rowStr = line.substring(i + 1, j);
                String[] cells = rowStr.split(",");
                char[] row = new char[cells.length];
                for (int k = 0; k < cells.length; k++) {
                    row[k] = cells[k].trim().replace("\"", "").charAt(0);
                }
                rows.add(row);
                i = j + 1;
            } else {
                i++;
            }
        }
        char[][] grid = rows.toArray(new char[0][]);
        System.out.println(new Solution().numIslands(grid));
    }
}
