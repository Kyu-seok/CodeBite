class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    rightSideView(root) {
        const view = [];
        let level = root ? [root] : [];
        while (level.length) {
            view.push(level[level.length - 1].val);
            const next = [];
            for (const node of level) {
                if (node.left) next.push(node.left);
                if (node.right) next.push(node.right);
            }
            level = next;
        }
        return view;
    }
}
