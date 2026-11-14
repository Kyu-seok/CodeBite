class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    listBuildPaths(root, target) {
        const paths = [];
        const path = [];
        const walk = (node, remaining) => {
            if (node === null) return;
            path.push(node.val);
            remaining -= node.val;
            if (node.left === null && node.right === null) {
                if (remaining === 0) paths.push(path.slice());
            } else {
                walk(node.left, remaining);
                walk(node.right, remaining);
            }
            path.pop();
        };
        walk(root, target);
        return paths;
    }
}
