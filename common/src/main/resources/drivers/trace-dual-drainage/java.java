import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();

        // Parse 2D int array
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
        int[][] heights = rows.toArray(new int[0][]);

        List<List<Integer>> result = new Solution().traceDualDrainage(heights);
        result.sort((a, b) -> a.get(0) != b.get(0) ? a.get(0) - b.get(0) : a.get(1) - b.get(1));
        System.out.println(JsonOutput.intList2D(result));
    }
}
