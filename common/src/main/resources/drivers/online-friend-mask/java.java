import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = Integer.parseUnsignedInt(sc.nextLine().trim());
        int result = new Solution().countActiveSensors(n);
        System.out.println(result);
    }
}
