import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String text1 = sc.nextLine().trim();
        String text2 = sc.nextLine().trim();
        int result = new Solution().longestCommonSubsequence(text1, text2);
        System.out.println(result);
    }
}
