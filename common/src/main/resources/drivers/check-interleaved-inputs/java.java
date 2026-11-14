import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String controllerA = sc.hasNextLine() ? sc.nextLine() : "";
        String controllerB = sc.hasNextLine() ? sc.nextLine() : "";
        String merged = sc.hasNextLine() ? sc.nextLine() : "";
        boolean result = new Solution().isInterleaving(controllerA, controllerB, merged);
        System.out.println(result);
    }
}
