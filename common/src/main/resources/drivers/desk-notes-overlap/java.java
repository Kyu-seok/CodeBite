import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String left = sc.nextLine().trim();
        String right = sc.nextLine().trim();
        int result = new Solution().longestCommonSubsequence(left, right);
        System.out.println(result);
    }
}
