import java.util.*;

{USER_CODE}

// {{LIB:TreeNode}}
// {{LIB:JsonOutput}}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        TreeNode root = TreeNode.fromArray(line);
        List<List<Integer>> result = new Solution().zigzagRows(root);
        System.out.println(JsonOutput.intList2D(result));
    }
}
