import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String num1 = sc.nextLine().trim();
        String num2 = sc.nextLine().trim();
        String result = new Solution().multiply(num1, num2);
        System.out.println(result);
    }
}
