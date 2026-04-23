import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String matrixLine = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());

        // Parse 2D array: [[1,3,5,7],[10,11,16,20],[23,30,34,60]]
        List<int[]> rows = new ArrayList<>();
        int i = 1; // skip leading '['
        while (i < matrixLine.length()) {
            if (matrixLine.charAt(i) == '[') {
                int j = matrixLine.indexOf(']', i);
                String sub = matrixLine.substring(i + 1, j);
                String[] parts = sub.split(",");
                int[] row = new int[parts.length];
                for (int k = 0; k < parts.length; k++) row[k] = Integer.parseInt(parts[k].trim());
                rows.add(row);
                i = j + 1;
            } else {
                i++;
            }
        }
        int[][] matrix = rows.toArray(new int[0][]);
        boolean result = new Solution().detectFlowValue(matrix, target);
        System.out.println(result);
    }
}
