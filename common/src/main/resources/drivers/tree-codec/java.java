import java.util.*;

// {{LIB:TreeNode}}

{USER_CODE}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String line = sc.nextLine().trim();
        TreeNode root = TreeNode.fromArray(line);
        Codec codec = new Codec();
        String serialized = codec.serialize(root);
        TreeNode result = codec.deserialize(serialized);
        System.out.println(TreeNode.toJsonArray(result));
    }
}
