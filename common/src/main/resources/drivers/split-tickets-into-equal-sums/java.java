import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String ticketsLine = sc.nextLine().trim();
        String inner = ticketsLine.substring(1, ticketsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] tickets = new int[parts.length];
        for (int i = 0; i < parts.length; i++) tickets[i] = Integer.parseInt(parts[i].trim());
        boolean result = new Solution().canSplitEqually(tickets);
        System.out.println(result);
    }
}
