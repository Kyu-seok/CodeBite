import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse 2D JSON string array into char[][]
        // Input: [["5","3",".",".","7",".",".",".","."],...]
        char[][] board = new char[9][9];
        int row = 0, col = 0, depth = 0;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '[') {
                depth++;
            } else if (c == ']') {
                if (depth == 2) {
                    row++;
                    col = 0;
                }
                depth--;
            } else if (c == '"') {
                i++;
                board[row][col] = line.charAt(i);
                col++;
                i++; // skip closing quote
            }
        }
        boolean result = new Solution().isValidSudoku(board);
        System.out.println(result);
    }
}
