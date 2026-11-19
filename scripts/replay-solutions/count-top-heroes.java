class Solution {
    public int countDominantHeroes(TreeNode root) {
        return count(root, Integer.MIN_VALUE);
    }

    private int count(TreeNode node, int best) {
        if (node == null) return 0;
        int here = node.val >= best ? 1 : 0;
        int next = Math.max(best, node.val);
        return here + count(node.left, next) + count(node.right, next);
    }
}
