import java.util.*;

{USER_CODE}

// {{LIB:ListNode}}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        ListNode head = ListNode.fromArray(line);
        new Solution().interleaveClips(head);
        System.out.println(ListNode.toJsonArray(head));
    }
}
