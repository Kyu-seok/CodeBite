import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int leftFlags = Integer.parseInt(sc.nextLine().trim());
        int rightFlags = Integer.parseInt(sc.nextLine().trim());
        int result = new Solution().countFlagMismatches(leftFlags, rightFlags);
        System.out.println(result);
    }
}
