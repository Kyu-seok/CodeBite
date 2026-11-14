class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    zigzagRows(root) {
        const rows = [];
        let level = root ? [root] : [];
        let leftToRight = true;
        while (level.length) {
            const row = level.map((node) => node.val);
            if (!leftToRight) row.reverse();
            rows.push(row);
            const next = [];
            for (const node of level) {
                if (node.left) next.push(node.left);
                if (node.right) next.push(node.right);
            }
            level = next;
            leftToRight = !leftToRight;
        }
        return rows;
    }
}
