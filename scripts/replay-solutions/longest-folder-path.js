class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    longestPathEdges(root) {
        let best = 0;
        const depth = (node) => {
            if (!node) return 0;
            const left = depth(node.left);
            const right = depth(node.right);
            best = Math.max(best, left + right);
            return 1 + Math.max(left, right);
        };
        depth(root);
        return best;
    }
}
