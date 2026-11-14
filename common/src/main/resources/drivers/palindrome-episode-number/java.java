import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int episode = Integer.parseInt(sc.nextLine().trim());
        boolean result = new Solution().isPalindrome(episode);
        System.out.println(result);
    }
}
