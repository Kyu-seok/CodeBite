class Solution {
    public int sumNumbers(TreeNode root) {
        return sum(root, 0);
    }

    private int sum(TreeNode node, int number) {
        if (node == null) return 0;
        number = number * 10 + node.val;
        if (node.left == null && node.right == null) return number;
        return sum(node.left, number) + sum(node.right, number);
    }
}
