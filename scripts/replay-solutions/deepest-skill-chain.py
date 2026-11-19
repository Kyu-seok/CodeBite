from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def maxSkillDepth(self, root: Optional[TreeNode]) -> int:
        # A tree's depth is one (its root) more than the deeper of its two subtrees'.
        if root is None:
            return 0
        return 1 + max(self.maxSkillDepth(root.left), self.maxSkillDepth(root.right))
