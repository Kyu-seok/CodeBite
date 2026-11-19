import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int candies = Integer.parseInt(sc.nextLine().trim());
        int result = new Solution().fewestBags(candies);
        System.out.println(result);
    }
}
