import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine().trim();
        int result = new Solution().countSubstrings(s);
        System.out.println(result);
    }
}
