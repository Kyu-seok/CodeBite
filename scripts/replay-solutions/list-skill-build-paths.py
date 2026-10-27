from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def listRuntimeBranches(self, root: Optional[TreeNode], target: int) -> list[list[int]]:
        paths: list[list[int]] = []
        # Right is pushed before left so the stack pops in left-first DFS order.
        stack = [(root, [root.val], root.val)] if root else []
        while stack:
            node, path, total = stack.pop()
            if not node.left and not node.right:
                if total == target:
                    paths.append(path)
                continue
            for child in (node.right, node.left):
                if child:
                    stack.append((child, path + [child.val], total + child.val))
        return paths
