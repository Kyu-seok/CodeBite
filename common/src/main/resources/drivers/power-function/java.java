import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        double x = Double.parseDouble(sc.nextLine().trim());
        int n = Integer.parseInt(sc.nextLine().trim());
        double result = new Solution().myPow(x, n);
        System.out.printf("%.5f%n", result);
    }
}
