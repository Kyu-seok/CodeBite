class Solution {
    public int maxSkillDepth(TreeNode root) {
        if (root == null) return 0;
        return 1 + Math.max(maxSkillDepth(root.left), maxSkillDepth(root.right));
    }
}
