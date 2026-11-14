class Solution {
    public void flattenAgenda(TreeNode root) {
        TreeNode node = root;
        while (node != null) {
            if (node.left != null) {
                TreeNode tail = node.left;
                while (tail.right != null) tail = tail.right;
                tail.right = node.right;
                node.right = node.left;
                node.left = null;
            }
            node = node.right;
        }
    }
}
