import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String message = sc.nextLine().trim();
        String line = sc.nextLine().trim();
        // Parse ["code","bite"]
        String inner = line.substring(1, line.length() - 1);
        List<String> words = new ArrayList<>();
        if (!inner.isEmpty()) {
            String[] parts = inner.split(",");
            for (String p : parts) words.add(p.trim().replaceAll("\"", ""));
        }
        System.out.println(new Solution().canSplitMessage(message, words));
    }
}
