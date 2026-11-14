import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String menuPriceLine = sc.nextLine().trim();
        int budget = Integer.parseInt(sc.nextLine().trim());
        String inner = menuPriceLine.substring(1, menuPriceLine.length() - 1);
        String[] parts = inner.split(",");
        int[] menuPrice = new int[parts.length];
        for (int i = 0; i < parts.length; i++) menuPrice[i] = Integer.parseInt(parts[i].trim());
        int[] result = new Solution().findMenuPair(menuPrice, budget);
        System.out.println(JsonOutput.intArray(result));
    }
}
