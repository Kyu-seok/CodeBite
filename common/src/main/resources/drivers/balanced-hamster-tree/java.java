import java.util.*;

// {{LIB:TreeNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        TreeNode root = TreeNode.fromArray(line);
        boolean result = new Solution().isBalanced(root);
        System.out.println(result ? "true" : "false");
    }
}
