import java.util.*;

// {{LIB:ListNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        int n = Integer.parseInt(sc.nextLine().trim());
        ListNode head = ListNode.fromArray(line);
        head = new Solution().dropTailBooking(head, n);
        System.out.println(ListNode.toJsonArray(head));
    }
}
