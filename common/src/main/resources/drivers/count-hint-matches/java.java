import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine().trim();
        String t = sc.nextLine().trim();
        long result = new Solution().countFilterMatches(s, t);
        System.out.println(result);
    }
}
