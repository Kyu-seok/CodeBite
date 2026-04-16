import java.util.*;

// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Parse [["MUC","LHR"],["JFK","MUC"]]
        List<List<String>> tickets = new ArrayList<>();
        if (!line.equals("[]")) {
            String inner = line.substring(1, line.length() - 1);
            int depth = 0;
            int start = 0;
            for (int i = 0; i < inner.length(); i++) {
                if (inner.charAt(i) == '[') { depth++; start = i; }
                else if (inner.charAt(i) == ']') {
                    depth--;
                    if (depth == 0) {
                        String sub = inner.substring(start + 1, i);
                        List<String> pair = new ArrayList<>();
                        String[] parts = sub.split(",");
                        for (String p : parts) pair.add(p.trim().replaceAll("\"", ""));
                        tickets.add(pair);
                    }
                }
            }
        }
        List<String> result = new Solution().findItinerary(tickets);
        System.out.println(JsonOutput.stringList(result));
    }
}
