import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [[1,3],[2,6],[8,10],[15,18]]
        List<int[]> list = new ArrayList<>();
        int i = 0;
        while (i < line.length()) {
            if (line.charAt(i) == '[' && i > 0) {
                int j = line.indexOf(']', i);
                String sub = line.substring(i + 1, j);
                String[] parts = sub.split(",");
                list.add(new int[]{Integer.parseInt(parts[0].trim()), Integer.parseInt(parts[1].trim())});
                i = j + 1;
            } else {
                i++;
            }
        }
        int[][] intervals = list.toArray(new int[0][]);
        int[][] result = new Solution().mergeSeatingWindows(intervals);
        System.out.println(JsonOutput.intArray2D(result));
    }
}
