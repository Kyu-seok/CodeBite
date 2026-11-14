class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    maxSkillDepth(root) {
        if (root === null) return 0;
        return 1 + Math.max(this.maxSkillDepth(root.left), this.maxSkillDepth(root.right));
    }
}
