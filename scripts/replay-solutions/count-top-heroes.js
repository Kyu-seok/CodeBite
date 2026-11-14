class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    countDominantHeroes(root) {
        let total = 0;
        const stack = root ? [[root, -Infinity]] : [];
        while (stack.length) {
            const [node, best] = stack.pop();
            if (node.val >= best) total++;
            const next = Math.max(best, node.val);
            if (node.left) stack.push([node.left, next]);
            if (node.right) stack.push([node.right, next]);
        }
        return total;
    }
}
