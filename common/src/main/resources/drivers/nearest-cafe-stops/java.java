import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        int k = Integer.parseInt(sc.nextLine().trim());

        String inner = line.substring(1, line.length() - 1);
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
        int[][] points = list.toArray(new int[0][]);

        int[][] result = new Solution().selectNearestStops(points, k);
        Arrays.sort(result, (a, b) -> a[0] != b[0] ? a[0] - b[0] : a[1] - b[1]);
        List<List<Integer>> res = new ArrayList<>();
        for (int[] r : result) res.add(Arrays.asList(r[0], r[1]));
        System.out.println(JsonOutput.intList2D(res));
    }
}
