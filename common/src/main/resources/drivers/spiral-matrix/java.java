import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();

        String inner = line.substring(1, line.length() - 1);
        List<int[]> rows = new ArrayList<>();
        int depth = 0, start = 0;
        for (int i = 0; i < inner.length(); i++) {
            if (inner.charAt(i) == '[') { depth++; start = i; }
            else if (inner.charAt(i) == ']') {
                depth--;
                if (depth == 0) {
                    String rowStr = inner.substring(start + 1, i);
                    String[] parts = rowStr.split(",");
                    int[] row = new int[parts.length];
                    for (int j = 0; j < parts.length; j++) row[j] = Integer.parseInt(parts[j].trim());
                    rows.add(row);
                }
            }
        }
        int[][] matrix = rows.toArray(new int[0][]);

        List<Integer> result = new Solution().spiralOrder(matrix);
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < result.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(result.get(i));
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
