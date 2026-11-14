class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    mirrorTree(root) {
        if (root === null) return null;
        const left = this.mirrorTree(root.left);
        root.left = this.mirrorTree(root.right);
        root.right = left;
        return root;
    }
}
