from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def isBalanced(self, root: Optional[TreeNode]) -> bool:
        # A subtree's height, or -1 as soon as some node below is unbalanced: then no later height matters.
        def height(node: Optional[TreeNode]) -> int:
            if node is None:
                return 0
            left = height(node.left)
            if left < 0:
                return -1
            right = height(node.right)
            if right < 0:
                return -1
            if abs(left - right) > 1:
                return -1
            return 1 + max(left, right)

        return height(root) >= 0
