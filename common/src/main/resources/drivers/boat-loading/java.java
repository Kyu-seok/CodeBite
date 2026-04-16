import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String weightsLine = sc.nextLine().trim();
        int capacity = Integer.parseInt(sc.nextLine().trim());
        String inner = weightsLine.substring(1, weightsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] weights = new int[parts.length];
        for (int i = 0; i < parts.length; i++) weights[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().boatLoading(weights, capacity);
        System.out.println(result);
    }
}
