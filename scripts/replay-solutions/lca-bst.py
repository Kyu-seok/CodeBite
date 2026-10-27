from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def lowestCommonAncestor(self, root: Optional[TreeNode], p: Optional[TreeNode],
                             q: Optional[TreeNode]) -> Optional[TreeNode]:
        low, high = sorted((p.val, q.val))
        node = root
        while node:
            if high < node.val:
                node = node.left
            elif low > node.val:
                node = node.right
            else:
                return node
        return None
