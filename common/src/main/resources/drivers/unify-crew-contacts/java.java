import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [["John","a@b.com"],["Mary","c@d.com"]]
        List<List<String>> accounts = new ArrayList<>();
        int i = 0;
        while (i < line.length()) {
            if (line.charAt(i) == '[' && i > 0 && line.charAt(i - 1) != '[' || (i > 1 && line.charAt(i) == '[' && line.charAt(i - 1) == ',')) {
                int depth = 0;
                int start = i;
                for (int j = i; j < line.length(); j++) {
                    if (line.charAt(j) == '[') depth++;
                    if (line.charAt(j) == ']') depth--;
                    if (depth == 0) {
                        String sub = line.substring(start + 1, j);
                        List<String> account = new ArrayList<>();
                        String[] parts = sub.split(",");
                        for (String p : parts) account.add(p.trim().replaceAll("\"", ""));
                        accounts.add(account);
                        i = j + 1;
                        break;
                    }
                }
            } else if (line.charAt(i) == '[' && (i == 0 || line.charAt(i - 1) == '[')) {
                // Check if this is an inner array start
                if (i > 0 && line.charAt(i - 1) == '[') {
                    int depth = 0;
                    int start = i;
                    for (int j = i; j < line.length(); j++) {
                        if (line.charAt(j) == '[') depth++;
                        if (line.charAt(j) == ']') depth--;
                        if (depth == 0) {
                            String sub = line.substring(start + 1, j);
                            List<String> account = new ArrayList<>();
                            String[] parts = sub.split(",");
                            for (String p : parts) account.add(p.trim().replaceAll("\"", ""));
                            accounts.add(account);
                            i = j + 1;
                            break;
                        }
                    }
                } else {
                    i++;
                }
            } else {
                i++;
            }
        }
        List<List<String>> result = new Solution().unifyContactIdentities(accounts);
        // Sort emails within each account (skip name at index 0)
        for (List<String> account : result) {
            String name = account.get(0);
            List<String> emails = account.subList(1, account.size());
            Collections.sort(emails);
        }
        // Sort accounts by first email
        result.sort((a, b) -> a.get(1).compareTo(b.get(1)));
        System.out.println(JsonOutput.stringList2D(result));
    }
}
