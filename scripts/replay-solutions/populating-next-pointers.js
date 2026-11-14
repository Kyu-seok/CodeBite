class Node {
    constructor(val = 0, left = null, right = null, next = null) {
        this.val = val;
        this.left = left;
        this.right = right;
        this.next = next;
    }
}

class Solution {
    connect(root) {
        let leftmost = root;
        while (leftmost && leftmost.left) {
            for (let node = leftmost; node; node = node.next) {
                node.left.next = node.right;
                if (node.next) node.right.next = node.next.left;
            }
            leftmost = leftmost.left;
        }
        return root;
    }
}
