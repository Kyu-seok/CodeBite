from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def deepestZoneChain(self, root: Optional[TreeNode]) -> int:
        depth = 0
        level = [root] if root else []
        while level:
            depth += 1
            level = [child for node in level for child in (node.left, node.right) if child]
        return depth
