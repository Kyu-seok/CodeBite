import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String boardLine = sc.nextLine().trim();
        String wordsLine = sc.nextLine().trim();

        // Parse 2D char array
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

        // Parse words array
        wordsLine = wordsLine.substring(1, wordsLine.length() - 1);
        String[] wordParts = wordsLine.split(",");
        String[] words = new String[wordParts.length];
        for (int i = 0; i < wordParts.length; i++) {
            words[i] = wordParts[i].trim().replace("\"", "");
        }

        List<String> result = new Solution().findWords(board, words);
        Collections.sort(result);
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < result.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(result.get(i)).append("\"");
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
