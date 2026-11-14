class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    rebuildTree(preorder, inorder) {
        const position = new Map(inorder.map((value, index) => [value, index]));
        let next = 0;
        const build = (low, high) => {
            if (low > high) return null;
            const node = new TreeNode(preorder[next++]);
            const middle = position.get(node.val);
            node.left = build(low, middle - 1);
            node.right = build(middle + 1, high);
            return node;
        };
        return build(0, inorder.length - 1);
    }
}
