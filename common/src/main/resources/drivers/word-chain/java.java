import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String beginWord = sc.nextLine().trim();
        String endWord = sc.nextLine().trim();
        String line = sc.nextLine().trim();
        // Parse JSON string array ["hot","dot","dog"]
        String inner = line.substring(1, line.length() - 1);
        List<String> wordList = new ArrayList<>();
        if (!inner.isEmpty()) {
            String[] parts = inner.split(",");
            for (String p : parts) {
                p = p.trim();
                wordList.add(p.substring(1, p.length() - 1));
            }
        }
        int result = new Solution().chainLength(beginWord, endWord, wordList);
        System.out.println(result);
    }
}
