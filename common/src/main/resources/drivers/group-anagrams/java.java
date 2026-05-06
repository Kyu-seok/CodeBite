import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse ["eat","tea","tan","ate","nat","bat"]
        String inner = line.substring(1, line.length() - 1);
        String[] strs;
        if (inner.isEmpty()) {
            strs = new String[0];
        } else {
            String[] parts = inner.split(",");
            strs = new String[parts.length];
            for (int i = 0; i < parts.length; i++) strs[i] = parts[i].trim().replaceAll("\"", "");
        }
        List<List<String>> result = new Solution().groupAnagrams(strs);
        // Sort for canonical form: sort each inner list, then sort outer
        for (List<String> group : result) Collections.sort(group);
        result.sort((a, b) -> {
            for (int i = 0; i < Math.min(a.size(), b.size()); i++) {
                int cmp = a.get(i).compareTo(b.get(i));
                if (cmp != 0) return cmp;
            }
            return a.size() - b.size();
        });
        System.out.println(JsonOutput.stringList2D(result));
    }
}
