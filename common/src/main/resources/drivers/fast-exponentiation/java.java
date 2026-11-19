import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        double base = Double.parseDouble(sc.nextLine().trim());
        int exponent = Integer.parseInt(sc.nextLine().trim());
        double result = new Solution().power(base, exponent);
        System.out.printf("%.5f%n", result);
    }
}
