from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def levelOrder(self, root: Optional[TreeNode]) -> list[list[int]]:
        levels: list[list[int]] = []
        level = [root] if root else []
        while level:
            levels.append([node.val for node in level])
            level = [child for node in level for child in (node.left, node.right) if child]
        return levels
