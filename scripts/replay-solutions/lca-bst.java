class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        int low = Math.min(p.val, q.val), high = Math.max(p.val, q.val);
        TreeNode node = root;
        while (node != null) {
            if (high < node.val) {
                node = node.left;
            } else if (low > node.val) {
                node = node.right;
            } else {
                return node;
            }
        }
        return null;
    }
}
