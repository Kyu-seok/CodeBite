import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        long statusWord = Long.parseLong(sc.nextLine().trim());
        long result = new Solution().reverseFlags(statusWord);
        System.out.println(result);
    }
}
