class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        List<List<Integer>> levels = new ArrayList<>();
        List<TreeNode> level = new ArrayList<>();
        if (root != null) level.add(root);
        while (!level.isEmpty()) {
            List<Integer> values = new ArrayList<>();
            List<TreeNode> next = new ArrayList<>();
            for (TreeNode node : level) {
                values.add(node.val);
                if (node.left != null) next.add(node.left);
                if (node.right != null) next.add(node.right);
            }
            levels.add(values);
            level = next;
        }
        return levels;
    }
}
