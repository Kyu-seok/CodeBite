import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        int k = Integer.parseInt(sc.nextLine().trim());
        // Parse ["apple","banana","apple"]
        String inner = line.substring(1, line.length() - 1);
        String[] words;
        if (inner.isEmpty()) {
            words = new String[0];
        } else {
            String[] parts = inner.split(",");
            words = new String[parts.length];
            for (int i = 0; i < parts.length; i++) words[i] = parts[i].trim().replaceAll("\"", "");
        }
        List<String> result = new Solution().rankTrendingTopics(words, k);
        System.out.println(JsonOutput.stringList(result));
    }
}
