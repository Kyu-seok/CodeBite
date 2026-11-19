import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int rows = Integer.parseInt(sc.nextLine().trim());
        int cols = Integer.parseInt(sc.nextLine().trim());
        int result = new Solution().countPaths(rows, cols);
        System.out.println(result);
    }
}
