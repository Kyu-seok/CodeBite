import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int reading = Integer.parseInt(sc.nextLine().trim());
        boolean result = new Solution().isCalm(reading);
        System.out.println(result ? "true" : "false");
    }
}
