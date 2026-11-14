import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        String inner = line.substring(1, line.length() - 1);
        String[] parts = inner.split(",");
        int[] scans = new int[parts.length];
        for (int i = 0; i < parts.length; i++) scans[i] = Integer.parseInt(parts[i].trim());
        new Solution().moveVoidsToEnd(scans);
        System.out.println(JsonOutput.intArray(scans));
    }
}
