import java.util.*;

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String ticketsLine = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());
        String inner = ticketsLine.substring(1, ticketsLine.length() - 1);
        String[] parts = inner.split(",");
        int[] tickets = new int[parts.length];
        for (int i = 0; i < parts.length; i++) tickets[i] = Integer.parseInt(parts[i].trim());
        int result = new Solution().countSignAssignments(tickets, target);
        System.out.println(result);
    }
}
