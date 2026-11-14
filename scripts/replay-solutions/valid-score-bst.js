class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    isValidBST(root) {
        const check = (node, low, high) => {
            if (node === null) return true;
            if (node.val <= low || node.val >= high) return false;
            return check(node.left, low, node.val) && check(node.right, node.val, high);
        };
        return check(root, -Infinity, Infinity);
    }
}
