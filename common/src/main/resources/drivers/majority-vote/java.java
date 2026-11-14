import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String votesLine = sc.nextLine().trim();
        String inner = votesLine.substring(1, votesLine.length() - 1);
        String[] parts = inner.split(",");
        int[] votes = new int[parts.length];
        for (int i = 0; i < parts.length; i++) votes[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().majorityVote(votes);
        System.out.println(result);
    }
}
