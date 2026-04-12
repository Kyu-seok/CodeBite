import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int numCourses = Integer.parseInt(sc.nextLine().trim());
        String line = sc.nextLine().trim();
        // Parse 2D int array [[1,0],[2,1]]
        int[][] prerequisites;
        String inner = line.substring(1, line.length() - 1);
        if (inner.isEmpty() || !inner.contains("[")) {
            prerequisites = new int[0][];
        } else {
            List<int[]> list = new ArrayList<>();
            int i = 0;
            while (i < inner.length()) {
                if (inner.charAt(i) == '[') {
                    int j = inner.indexOf(']', i);
                    String pairStr = inner.substring(i + 1, j);
                    String[] parts = pairStr.split(",");
                    int[] pair = new int[parts.length];
                    for (int k = 0; k < parts.length; k++) pair[k] = Integer.parseInt(parts[k].trim());
                    list.add(pair);
                    i = j + 1;
                } else {
                    i++;
                }
            }
            prerequisites = list.toArray(new int[0][]);
        }
        boolean result = new Solution().canFinish(numCourses, prerequisites);
        System.out.println(result);
    }
}
