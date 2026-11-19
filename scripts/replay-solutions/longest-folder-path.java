class Solution {
    private int best = 0;

    public int longestPathEdges(TreeNode root) {
        best = 0;
        depth(root);
        return best;
    }

    private int depth(TreeNode node) {
        if (node == null) return 0;
        int left = depth(node.left);
        int right = depth(node.right);
        best = Math.max(best, left + right);
        return 1 + Math.max(left, right);
    }
}
