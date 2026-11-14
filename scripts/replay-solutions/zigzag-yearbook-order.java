class Solution {
    public List<List<Integer>> zigzagRows(TreeNode root) {
        List<List<Integer>> rows = new ArrayList<>();
        if (root == null) return rows;
        List<TreeNode> level = new ArrayList<>();
        level.add(root);
        boolean leftToRight = true;
        while (!level.isEmpty()) {
            List<Integer> row = new ArrayList<>();
            List<TreeNode> next = new ArrayList<>();
            for (TreeNode node : level) {
                row.add(node.val);
                if (node.left != null) next.add(node.left);
                if (node.right != null) next.add(node.right);
            }
            if (!leftToRight) Collections.reverse(row);
            rows.add(row);
            leftToRight = !leftToRight;
            level = next;
        }
        return rows;
    }
}
