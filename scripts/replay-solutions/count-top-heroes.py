from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def tallyDominantBlocks(self, root: Optional[TreeNode]) -> int:
        count = 0
        stack = [(root, float("-inf"))] if root else []
        while stack:
            node, best = stack.pop()
            if node.val >= best:
                count += 1
                best = node.val
            for child in (node.left, node.right):
                if child:
                    stack.append((child, best))
        return count
