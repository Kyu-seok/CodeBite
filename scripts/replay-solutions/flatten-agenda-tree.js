class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    flattenAgenda(root) {
        let node = root;
        while (node !== null) {
            if (node.left !== null) {
                let tail = node.left;
                while (tail.right !== null) tail = tail.right;
                tail.right = node.right;
                node.right = node.left;
                node.left = null;
            }
            node = node.right;
        }
    }
}
