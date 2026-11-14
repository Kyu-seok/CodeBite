import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String phrase = sc.nextLine().trim();
        boolean result = new Solution().isPalindrome(phrase);
        System.out.println(result);
    }
}
