import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String lockersLine = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());
        String inner = lockersLine.substring(1, lockersLine.length() - 1);
        String[] parts = inner.split(",");
        int[] lockers = new int[parts.length];
        for (int i = 0; i < parts.length; i++) lockers[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().findLocker(lockers, target);
        System.out.println(result);
    }
}
