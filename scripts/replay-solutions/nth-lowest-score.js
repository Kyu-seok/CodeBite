class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    nthLowestScore(root, k) {
        const stack = [];
        let node = root;
        while (node || stack.length) {
            while (node) {
                stack.push(node);
                node = node.left;
            }
            node = stack.pop();
            if (--k === 0) return node.val;
            node = node.right;
        }
        return -1;
    }
}
