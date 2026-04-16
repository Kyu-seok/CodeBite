import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int amount = Integer.parseInt(sc.nextLine().trim());
        String coinsLine = sc.nextLine().trim();
        String inner = coinsLine.substring(1, coinsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] coins = new int[parts.length];
        for (int i = 0; i < parts.length; i++) coins[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().changeMaker(amount, coins);
        System.out.println(result);
    }
}
