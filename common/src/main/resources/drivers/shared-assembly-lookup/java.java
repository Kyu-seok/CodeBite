import java.util.*;

// {{LIB:TreeNode}}

{USER_CODE}

public class Main {
    static TreeNode findNode(TreeNode root, int val) {
        if (root == null) return null;
        if (root.val == val) return root;
        TreeNode left = findNode(root.left, val);
        if (left != null) return left;
        return findNode(root.right, val);
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        int pVal = Integer.parseInt(sc.nextLine().trim());
        int qVal = Integer.parseInt(sc.nextLine().trim());
        TreeNode root = TreeNode.fromArray(line);
        TreeNode p = findNode(root, pVal);
        TreeNode q = findNode(root, qVal);
        TreeNode result = new Solution().findSharedAssembly(root, p, q);
        System.out.println(result.val);
    }
}
