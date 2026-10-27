from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def sumNumbers(self, root: Optional[TreeNode]) -> int:
        total = 0
        stack = [(root, root.val)] if root else []
        while stack:
            node, number = stack.pop()
            if not node.left and not node.right:
                total += number
            for child in (node.left, node.right):
                if child:
                    stack.append((child, number * 10 + child.val))
        return total
