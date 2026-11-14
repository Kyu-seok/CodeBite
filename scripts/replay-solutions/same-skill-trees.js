class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    isSameTree(p, q) {
        if (p === null || q === null) return p === q;
        return p.val === q.val && this.isSameTree(p.left, q.left) && this.isSameTree(p.right, q.right);
    }
}
