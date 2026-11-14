import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String digits = sc.nextLine().trim();
        int result = new Solution().countDecodings(digits);
        System.out.println(result);
    }
}
