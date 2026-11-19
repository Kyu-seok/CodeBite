from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def sumNumbers(self, root: Optional[TreeNode]) -> int:
        total = 0

        # Each call carries the number spelled from the root down to its node; a leaf adds its number to the total.
        def walk(node: TreeNode, number: int) -> None:
            nonlocal total
            number = number * 10 + node.val
            if not node.left and not node.right:
                total += number
            for child in (node.left, node.right):
                if child:
                    walk(child, number)

        if root:
            walk(root, 0)
        return total
