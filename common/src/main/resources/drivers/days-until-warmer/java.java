import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String readingsLine = sc.nextLine().trim();
        String inner = readingsLine.substring(1, readingsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] readings = new int[parts.length];
        for (int i = 0; i < parts.length; i++) readings[i] = Integer.parseInt(parts[i].trim());
        int[] result = new Solution().daysUntilWarmer(readings);
        System.out.println(JsonOutput.intArray(result));
    }
}
