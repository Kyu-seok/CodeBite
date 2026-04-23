import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [["X","O"],["O","X"]]
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
        char[][] board = rows.toArray(new char[0][]);
        new Solution().seizeEnclosedZones(board);
        // Output as 2D string array
        StringBuilder sb = new StringBuilder("[");
        for (int r = 0; r < board.length; r++) {
            if (r > 0) sb.append(",");
            sb.append("[");
            for (int c = 0; c < board[r].length; c++) {
                if (c > 0) sb.append(",");
                sb.append("\"").append(board[r][c]).append("\"");
            }
            sb.append("]");
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
