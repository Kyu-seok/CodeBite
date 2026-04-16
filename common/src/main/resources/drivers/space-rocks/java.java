import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        String inner = line.substring(1, line.length() - 1);
        int[] rocks;
        if (inner.isEmpty()) {
            rocks = new int[0];
        } else {
            String[] parts = inner.split(",");
            rocks = new int[parts.length];
            for (int i = 0; i < parts.length; i++) rocks[i] = Integer.parseInt(parts[i].trim());
        }
        int[] result = new Solution().spaceRocks(rocks);
        System.out.println(JsonOutput.intArray(result));
    }
}
