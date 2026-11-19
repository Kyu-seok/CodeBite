import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String notes = sc.nextLine().trim();
        String target = sc.nextLine().trim();
        long result = new Solution().countHintMatches(notes, target);
        System.out.println(result);
    }
}
