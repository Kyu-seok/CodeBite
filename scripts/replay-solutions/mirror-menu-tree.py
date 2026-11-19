from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def mirrorTree(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        # The mirror of a tree is its root with the mirror of its right subtree on the left
        # and the mirror of its left subtree on the right.
        if root is None:
            return None
        mirror = TreeNode(root.val)
        mirror.left = self.mirrorTree(root.right)
        mirror.right = self.mirrorTree(root.left)
        return mirror
