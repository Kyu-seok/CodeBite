import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        String inner = line.substring(1, line.length() - 1);
        int[] height;
        if (inner.isEmpty()) {
            height = new int[0];
        } else {
            String[] parts = inner.split(",");
            height = new int[parts.length];
            for (int i = 0; i < parts.length; i++) height[i] = Integer.parseInt(parts[i].trim());
        }
        int result = new Solution().poolBetweenWalls(height);
        System.out.println(result);
    }
}
