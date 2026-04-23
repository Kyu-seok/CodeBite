import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        // Remove outer brackets, split by comma, strip quotes
        line = line.substring(1, line.length() - 1);
        String[] tokens = line.isEmpty() ? new String[0] : line.split(",");
        for (int i = 0; i < tokens.length; i++) {
            tokens[i] = tokens[i].trim().replaceAll("\"", "");
        }
        int result = new Solution().foldBaleOps(tokens);
        System.out.println(result);
    }
}
