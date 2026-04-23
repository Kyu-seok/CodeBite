import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String intervalsLine = sc.nextLine().trim();
        String queriesLine = sc.nextLine().trim();
        // Parse intervals [[1,4],[2,4],[3,6],[2,8]]
        List<int[]> list = new ArrayList<>();
        int i = 0;
        while (i < intervalsLine.length()) {
            if (intervalsLine.charAt(i) == '[' && i > 0) {
                int j = intervalsLine.indexOf(']', i);
                String sub = intervalsLine.substring(i + 1, j);
                String[] parts = sub.split(",");
                list.add(new int[]{Integer.parseInt(parts[0].trim()), Integer.parseInt(parts[1].trim())});
                i = j + 1;
            } else {
                i++;
            }
        }
        int[][] intervals = list.toArray(new int[0][]);
        // Parse queries [2,3,4,5]
        String inner = queriesLine.substring(1, queriesLine.length() - 1);
        String[] qParts = inner.split(",");
        int[] queries = new int[qParts.length];
        for (int k = 0; k < qParts.length; k++) queries[k] = Integer.parseInt(qParts[k].trim());
        int[] result = new Solution().findTightestBooking(intervals, queries);
        System.out.println(JsonOutput.intArray(result));
    }
}
