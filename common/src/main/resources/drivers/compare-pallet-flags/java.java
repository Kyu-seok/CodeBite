import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int x = Integer.parseInt(sc.nextLine().trim());
        int y = Integer.parseInt(sc.nextLine().trim());
        int result = new Solution().countFlagMismatches(x, y);
        System.out.println(result);
    }
}
