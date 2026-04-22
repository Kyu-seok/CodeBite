import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = Integer.parseInt(sc.nextLine().trim());
        boolean result = new Solution().isSoloSpecies(n);
        System.out.println(result);
    }
}
