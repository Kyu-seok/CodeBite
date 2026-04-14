import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String intLine = sc.nextLine().trim();
        String newLine = sc.nextLine().trim();

        int[][] intervals;
        if (intLine.equals("[]")) {
            intervals = new int[0][];
        } else {
            String inner = intLine.substring(1, intLine.length() - 1);
            List<int[]> list = new ArrayList<>();
            int depth = 0, start = 0;
            for (int i = 0; i < inner.length(); i++) {
                if (inner.charAt(i) == '[') { depth++; start = i; }
                else if (inner.charAt(i) == ']') {
                    depth--;
                    if (depth == 0) {
                        String p = inner.substring(start + 1, i);
                        String[] parts = p.split(",");
                        list.add(new int[]{Integer.parseInt(parts[0].trim()), Integer.parseInt(parts[1].trim())});
                    }
                }
            }
            intervals = list.toArray(new int[0][]);
        }

        String ni = newLine.substring(1, newLine.length() - 1);
        String[] np = ni.split(",");
        int[] newInterval = {Integer.parseInt(np[0].trim()), Integer.parseInt(np[1].trim())};

        int[][] result = new Solution().insert(intervals, newInterval);
        List<List<Integer>> res = new ArrayList<>();
        for (int[] r : result) res.add(Arrays.asList(r[0], r[1]));
        System.out.println(JsonOutput.intList2D(res));
    }
}
