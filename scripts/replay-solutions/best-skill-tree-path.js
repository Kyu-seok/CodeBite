class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    maxPathSum(root) {
        let best = -Infinity;
        const gain = (node) => {
            if (node === null) return 0;
            const left = Math.max(gain(node.left), 0);
            const right = Math.max(gain(node.right), 0);
            best = Math.max(best, node.val + left + right);
            return node.val + Math.max(left, right);
        };
        gain(root);
        return best;
    }
}
