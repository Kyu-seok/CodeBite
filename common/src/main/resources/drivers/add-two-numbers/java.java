import java.util.*;

// {{LIB:ListNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line1 = sc.nextLine().trim();
        String line2 = sc.nextLine().trim();
        ListNode l1 = ListNode.fromArray(line1);
        ListNode l2 = ListNode.fromArray(line2);
        ListNode result = new Solution().addTwoNumbers(l1, l2);
        System.out.println(ListNode.toJsonArray(result));
    }
}
