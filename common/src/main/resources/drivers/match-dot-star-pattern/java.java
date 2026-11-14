import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine().trim();
        String p = sc.nextLine().trim();
        boolean result = new Solution().isMatch(s, p);
        System.out.println(result);
    }
}
