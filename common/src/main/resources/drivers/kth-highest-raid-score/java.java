import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String scoresLine = sc.nextLine().trim();
        int k = Integer.parseInt(sc.nextLine().trim());
        String inner = scoresLine.substring(1, scoresLine.length() - 1);
        String[] parts = inner.split(",");
        int[] scores = new int[parts.length];
        for (int i = 0; i < parts.length; i++) scores[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().kthHighestScore(scores, k);
        System.out.println(result);
    }
}
