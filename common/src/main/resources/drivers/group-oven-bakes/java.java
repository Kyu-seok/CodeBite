import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String handLine = sc.nextLine().trim();
        int groupSize = Integer.parseInt(sc.nextLine().trim());
        String inner = handLine.substring(1, handLine.length() - 1);
        String[] parts = inner.split(",");
        int[] hand = new int[parts.length];
        for (int i = 0; i < parts.length; i++) hand[i] = Integer.parseInt(parts[i].trim());
        boolean result = new Solution().canGroupBakes(hand, groupSize);
        System.out.println(result);
    }
}
