import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String boardLine = sc.nextLine().trim();
        String word = sc.nextLine().trim();

        boardLine = boardLine.substring(1, boardLine.length() - 1);
        List<char[]> boardList = new ArrayList<>();
        int depth = 0;
        int start = 0;
        for (int i = 0; i < boardLine.length(); i++) {
            if (boardLine.charAt(i) == '[') { depth++; start = i; }
            else if (boardLine.charAt(i) == ']') {
                depth--;
                if (depth == 0) {
                    String row = boardLine.substring(start + 1, i);
                    String[] cells = row.split(",");
                    char[] rowArr = new char[cells.length];
                    for (int j = 0; j < cells.length; j++) {
                        rowArr[j] = cells[j].trim().replace("\"", "").charAt(0);
                    }
                    boardList.add(rowArr);
                }
            }
        }
        char[][] board = boardList.toArray(new char[0][]);
        boolean result = new Solution().traceZonePath(board, word);
        System.out.println(result ? "true" : "false");
    }
}
