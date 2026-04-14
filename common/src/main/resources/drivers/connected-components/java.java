import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = Integer.parseInt(sc.nextLine().trim());
        String line = sc.nextLine().trim();

        int[][] edges;
        if (line.equals("[]")) {
            edges = new int[0][];
        } else {
            String inner = line.substring(1, line.length() - 1);
            List<int[]> list = new ArrayList<>();
            int depth = 0;
            int start = 0;
            for (int i = 0; i < inner.length(); i++) {
                if (inner.charAt(i) == '[') { depth++; start = i; }
                else if (inner.charAt(i) == ']') {
                    depth--;
                    if (depth == 0) {
                        String pairStr = inner.substring(start + 1, i);
                        String[] parts = pairStr.split(",");
                        list.add(new int[]{Integer.parseInt(parts[0].trim()), Integer.parseInt(parts[1].trim())});
                    }
                }
            }
            edges = list.toArray(new int[0][]);
        }

        int result = new Solution().countComponents(n, edges);
        System.out.println(result);
    }
}
