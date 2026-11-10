import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String feed = sc.nextLine().trim();
        int result = new Solution().longestGenreWindow(feed);
        System.out.println(result);
    }
}
