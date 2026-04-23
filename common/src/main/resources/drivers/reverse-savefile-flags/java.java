import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        long n = Long.parseLong(sc.nextLine().trim());
        long result = new Solution().reversePrinterFlags(n);
        System.out.println(result);
    }
}
