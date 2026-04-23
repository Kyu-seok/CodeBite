import java.util.*;

// {{LIB:TreeNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        TreeNode root = TreeNode.fromArray(line);
        TreeSerializer codec = new TreeSerializer();
        String serialized = codec.pack(root);
        TreeNode result = codec.unpack(serialized);
        System.out.println(TreeNode.toJsonArray(result));
    }
}
