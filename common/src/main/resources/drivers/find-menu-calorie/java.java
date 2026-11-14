import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String menuLine = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());

        // Parse 2D array: [[1,4,7,11,15],[2,5,8,12,19],...]
        List<int[]> rows = new ArrayList<>();
        int i = 1; // skip leading '['
        while (i < menuLine.length()) {
            if (menuLine.charAt(i) == '[') {
                int j = menuLine.indexOf(']', i);
                String sub = menuLine.substring(i + 1, j);
                String[] parts = sub.split(",");
                int[] row = new int[parts.length];
                for (int k = 0; k < parts.length; k++) row[k] = Integer.parseInt(parts[k].trim());
                rows.add(row);
                i = j + 1;
            } else {
                i++;
            }
        }
        int[][] menu = rows.toArray(new int[0][]);
        boolean result = new Solution().findCalorie(menu, target);
        System.out.println(result);
    }
}
