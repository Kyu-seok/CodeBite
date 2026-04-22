import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine().trim();
        String result = new Solution().orderRecipeBakes(s);
        if (result == null || result.isEmpty()) {
            System.out.println("");
        } else if (isValid(s, result)) {
            System.out.println("valid");
        } else {
            System.out.println("INVALID:" + result);
        }
    }

    private static boolean isValid(String original, String result) {
        if (result.length() != original.length()) return false;
        char[] o = original.toCharArray();
        char[] r = result.toCharArray();
        Arrays.sort(o);
        Arrays.sort(r);
        if (!Arrays.equals(o, r)) return false;
        for (int i = 1; i < result.length(); i++) {
            if (result.charAt(i) == result.charAt(i - 1)) return false;
        }
        return true;
    }
}
