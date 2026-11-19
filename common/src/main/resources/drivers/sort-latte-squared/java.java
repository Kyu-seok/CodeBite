import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String driftsLine = sc.nextLine().trim();
        String inner = driftsLine.substring(1, driftsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] drifts = new int[parts.length];
        for (int i = 0; i < parts.length; i++) drifts[i] = Integer.parseInt(parts[i].trim());
        int[] result = new Solution().sortedSquaredDrifts(drifts);
        System.out.println(JsonOutput.intArray(result));
    }
}
