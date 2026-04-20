import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String s1 = sc.hasNextLine() ? sc.nextLine() : "";
        String s2 = sc.hasNextLine() ? sc.nextLine() : "";
        String s3 = sc.hasNextLine() ? sc.nextLine() : "";
        boolean result = new Solution().isWeave(s1, s2, s3);
        System.out.println(result);
    }
}
