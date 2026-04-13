import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String numsLine = sc.nextLine().trim();
        String inner = numsLine.substring(1, numsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] temperatures = new int[parts.length];
        for (int i = 0; i < parts.length; i++) temperatures[i] = Integer.parseInt(parts[i].trim());
        int[] result = new Solution().dailyTemperatures(temperatures);
        System.out.println(JsonOutput.intArray(result));
    }
}
