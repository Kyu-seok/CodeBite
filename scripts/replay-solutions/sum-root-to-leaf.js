class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    sumNumbers(root) {
        const sum = (node, number) => {
            if (!node) return 0;
            number = number * 10 + node.val;
            if (!node.left && !node.right) return number;
            return sum(node.left, number) + sum(node.right, number);
        };
        return sum(root, 0);
    }
}
