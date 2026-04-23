import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = Integer.parseInt(sc.nextLine().trim());
        String line = sc.nextLine().trim();
        // Parse 2D int array [[0,1,100],[1,2,100]]
        int[][] flights;
        String inner = line.substring(1, line.length() - 1);
        if (inner.isEmpty() || !inner.contains("[")) {
            flights = new int[0][];
        } else {
            List<int[]> list = new ArrayList<>();
            int i = 0;
            while (i < inner.length()) {
                if (inner.charAt(i) == '[') {
                    int j = inner.indexOf(']', i);
                    String tripStr = inner.substring(i + 1, j);
                    String[] parts = tripStr.split(",");
                    int[] trip = new int[parts.length];
                    for (int k = 0; k < parts.length; k++) trip[k] = Integer.parseInt(parts[k].trim());
                    list.add(trip);
                    i = j + 1;
                } else {
                    i++;
                }
            }
            flights = list.toArray(new int[0][]);
        }
        int src = Integer.parseInt(sc.nextLine().trim());
        int dst = Integer.parseInt(sc.nextLine().trim());
        int k = Integer.parseInt(sc.nextLine().trim());
        int result = new Solution().relayDispatchCost(n, flights, src, dst, k);
        System.out.println(result);
    }
}
