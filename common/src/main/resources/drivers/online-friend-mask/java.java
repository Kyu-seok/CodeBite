import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int friendMask = Integer.parseUnsignedInt(sc.nextLine().trim());
        int result = new Solution().countOnlineFriends(friendMask);
        System.out.println(result);
    }
}
