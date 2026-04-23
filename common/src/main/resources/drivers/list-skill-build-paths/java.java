import java.util.*;

// {{LIB:TreeNode}}
// {{LIB:JsonOutput}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        int target = Integer.parseInt(sc.nextLine().trim());
        TreeNode root = TreeNode.fromArray(line);
        List<List<Integer>> result = new Solution().listRuntimeBranches(root, target);
        result.sort((a, b) -> {
            for (int i = 0; i < Math.min(a.size(), b.size()); i++) {
                if (!a.get(i).equals(b.get(i))) return a.get(i) - b.get(i);
            }
            return a.size() - b.size();
        });
        System.out.println(JsonOutput.intList2D(result));
    }
}
