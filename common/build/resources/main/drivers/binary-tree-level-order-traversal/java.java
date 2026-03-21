import java.util.*;

// {{LIB:TreeNode}}
// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        TreeNode root = TreeNode.fromArray(line);
        List<List<Integer>> result = new Solution().levelOrder(root);
        System.out.println(JsonOutput.intList2D(result));
    }
}
