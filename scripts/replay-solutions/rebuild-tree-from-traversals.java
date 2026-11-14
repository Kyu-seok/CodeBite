class Solution {
    private int next;

    public TreeNode rebuildTree(int[] preorder, int[] inorder) {
        java.util.Map<Integer, Integer> position = new java.util.HashMap<>();
        for (int i = 0; i < inorder.length; i++) position.put(inorder[i], i);
        next = 0;
        return build(preorder, position, 0, inorder.length - 1);
    }

    private TreeNode build(int[] preorder, java.util.Map<Integer, Integer> position, int low, int high) {
        if (low > high) return null;
        TreeNode node = new TreeNode(preorder[next++]);
        int middle = position.get(node.val);
        node.left = build(preorder, position, low, middle - 1);
        node.right = build(preorder, position, middle + 1, high);
        return node;
    }
}
