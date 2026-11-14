class Solution {
    public List<Integer> rightSideView(TreeNode root) {
        List<Integer> view = new ArrayList<>();
        List<TreeNode> level = new ArrayList<>();
        if (root != null) level.add(root);
        while (!level.isEmpty()) {
            view.add(level.get(level.size() - 1).val);
            List<TreeNode> next = new ArrayList<>();
            for (TreeNode node : level) {
                if (node.left != null) next.add(node.left);
                if (node.right != null) next.add(node.right);
            }
            level = next;
        }
        return view;
    }
}
