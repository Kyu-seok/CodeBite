import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String pilesLine = sc.nextLine().trim();
        int hours = Integer.parseInt(sc.nextLine().trim());
        String inner = pilesLine.substring(1, pilesLine.length() - 1);
        String[] parts = inner.split(",");
        int[] piles = new int[parts.length];
        for (int i = 0; i < parts.length; i++) piles[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().minEatingRate(piles, hours);
        System.out.println(result);
    }
}
