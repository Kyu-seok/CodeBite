import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String s1 = sc.nextLine().trim();
        String s2 = sc.nextLine().trim();
        boolean result = new Solution().matchesZoneAnagram(s1, s2);
        System.out.println(result);
    }
}
