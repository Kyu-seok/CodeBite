import java.util.*;

// {{LIB:TreeNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        TreeNode root = TreeNode.fromArray(line);
        new Solution().unrollSchedule(root);
        StringBuilder sb = new StringBuilder("[");
        TreeNode curr = root;
        boolean first = true;
        while (curr != null) {
            if (!first) sb.append(",");
            sb.append(curr.val);
            first = false;
            curr = curr.right;
        }
        sb.append("]");
        System.out.println(sb.toString());
    }
}
