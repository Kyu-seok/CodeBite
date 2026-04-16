import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse 2D int array [[1,3],[0,2],[1,3],[0,2]]
        int[][] graph;
        List<List<Integer>> lists = new ArrayList<>();
        String inner = line.substring(1, line.length() - 1);
        int i = 0;
        while (i < inner.length()) {
            if (inner.charAt(i) == '[') {
                int j = inner.indexOf(']', i);
                String content = inner.substring(i + 1, j);
                List<Integer> list = new ArrayList<>();
                if (!content.isEmpty()) {
                    for (String s : content.split(",")) {
                        list.add(Integer.parseInt(s.trim()));
                    }
                }
                lists.add(list);
                i = j + 1;
            } else {
                i++;
            }
        }
        graph = new int[lists.size()][];
        for (int k = 0; k < lists.size(); k++) {
            graph[k] = lists.get(k).stream().mapToInt(Integer::intValue).toArray();
        }
        boolean result = new Solution().isTwoColorable(graph);
        System.out.println(result);
    }
}
