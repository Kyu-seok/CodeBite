import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String traysLine = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());
        String inner = traysLine.substring(1, traysLine.length() - 1);
        String[] parts = inner.split(",");
        int[] trays = new int[parts.length];
        for (int i = 0; i < parts.length; i++) trays[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().shortestCookieSpan(trays, target);
        System.out.println(result);
    }
}
