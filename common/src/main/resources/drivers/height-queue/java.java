import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]
        List<int[]> rows = new ArrayList<>();
        int i = 0;
        while (i < line.length()) {
            if (line.charAt(i) == '[' && i > 0) {
                int j = line.indexOf(']', i);
                String sub = line.substring(i + 1, j);
                String[] parts = sub.split(",");
                int[] row = new int[parts.length];
                for (int k = 0; k < parts.length; k++) row[k] = Integer.parseInt(parts[k].trim());
                rows.add(row);
                i = j + 1;
            } else {
                i++;
            }
        }
        int[][] people = rows.toArray(new int[0][]);
        int[][] result = new Solution().reconstructQueue(people);
        System.out.println(JsonOutput.intArray2D(result));
    }
}
