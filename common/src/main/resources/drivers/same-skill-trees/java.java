import java.util.*;

// {{LIB:TreeNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line1 = sc.nextLine().trim();
        String line2 = sc.nextLine().trim();
        TreeNode p = TreeNode.fromArray(line1);
        TreeNode q = TreeNode.fromArray(line2);
        boolean result = new Solution().matchCatalogLayout(p, q);
        System.out.println(result);
    }
}
