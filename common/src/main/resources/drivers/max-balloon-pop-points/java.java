import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String balloonsLine = sc.nextLine().trim();
        String inner = balloonsLine.substring(1, balloonsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] balloons = new int[parts.length];
        for (int i = 0; i < parts.length; i++) balloons[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().maxPopPoints(balloons);
        System.out.println(result);
    }
}
