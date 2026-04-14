import java.util.*;

// {{LIB:TreeNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String preLine = sc.nextLine().trim();
        String inLine = sc.nextLine().trim();
        String preInner = preLine.substring(1, preLine.length() - 1);
        String inInner = inLine.substring(1, inLine.length() - 1);
        int[] preorder = preInner.isEmpty() ? new int[0] : Arrays.stream(preInner.split(",")).mapToInt(s -> Integer.parseInt(s.trim())).toArray();
        int[] inorder = inInner.isEmpty() ? new int[0] : Arrays.stream(inInner.split(",")).mapToInt(s -> Integer.parseInt(s.trim())).toArray();
        TreeNode result = new Solution().buildTree(preorder, inorder);
        System.out.println(TreeNode.toJsonArray(result));
    }
}
