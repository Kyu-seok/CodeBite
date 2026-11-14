import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String comboLine = sc.nextLine().trim();
        int k = Integer.parseInt(sc.nextLine().trim());
        String inner = comboLine.substring(1, comboLine.length() - 1);
        String[] parts = inner.split(",");
        int[] combo = new int[parts.length];
        for (int i = 0; i < parts.length; i++) combo[i] = Integer.parseInt(parts[i].trim());
        int[] result = new Solution().peakComboPerWindow(combo, k);
        System.out.println(JsonOutput.intArray(result));
    }
}
