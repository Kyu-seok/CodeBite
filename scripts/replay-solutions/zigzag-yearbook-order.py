from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def alternateWardSweep(self, root: Optional[TreeNode]) -> list[list[int]]:
        rows: list[list[int]] = []
        level = [root] if root else []
        while level:
            values = [node.val for node in level]
            rows.append(values if len(rows) % 2 == 0 else values[::-1])
            level = [child for node in level for child in (node.left, node.right) if child]
        return rows
