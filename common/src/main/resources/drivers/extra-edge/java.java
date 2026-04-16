import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [[1,2],[1,3],[2,3]]
        List<int[]> edgeList = new ArrayList<>();
        int i = 0;
        while (i < line.length()) {
            if (line.charAt(i) == '[' && i > 0) {
                int j = line.indexOf(']', i);
                String sub = line.substring(i + 1, j);
                String[] parts = sub.split(",");
                int[] edge = new int[parts.length];
                for (int k = 0; k < parts.length; k++) edge[k] = Integer.parseInt(parts[k].trim());
                edgeList.add(edge);
                i = j + 1;
            } else {
                i++;
            }
        }
        int[][] edges = edgeList.toArray(new int[0][]);
        int[] result = new Solution().findExtraEdge(edges);
        System.out.println(JsonOutput.intArray(result));
    }
}
