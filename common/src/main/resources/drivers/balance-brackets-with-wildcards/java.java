import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String brackets = sc.nextLine().trim();
        boolean result = new Solution().canBalance(brackets);
        System.out.println(result);
    }
}
