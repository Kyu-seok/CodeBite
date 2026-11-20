class Solution {
    public boolean containsSubBranch(TreeNode root, TreeNode subRoot) {
        // A preorder walk with "#" for missing children identifies a subtree's shape and values,
        // so subRoot is a subtree of root exactly when its walk appears whole in root's walk.
        return walk(root).contains(walk(subRoot));
    }

    private String walk(TreeNode node) {
        StringBuilder parts = new StringBuilder(",");
        Deque<TreeNode> stack = new ArrayDeque<>();
        TreeNode current = node;
        while (true) {
            if (current == null) {
                parts.append("#,");
                if (stack.isEmpty()) break;
                current = stack.pop().right;
            } else {
                parts.append(current.val).append(',');
                stack.push(current);
                current = current.left;
            }
        }
        return parts.toString();
    }
}
