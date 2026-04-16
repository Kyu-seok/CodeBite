import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        String inner = line.substring(1, line.length() - 1);
        String[] parts = inner.split(",");
        int[] items = new int[parts.length];
        for (int i = 0; i < parts.length; i++) items[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().fruitPicker(items);
        System.out.println(result);
    }
}
