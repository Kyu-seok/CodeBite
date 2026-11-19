from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def listBuildPaths(self, root: Optional[TreeNode], target: int) -> list[list[int]]:
        paths: list[list[int]] = []
        path: list[int] = []

        # Depth first, left before right: the path holds the open calls' values, so a leaf whose sum hits target
        # copies it out, and each call takes its own value off again as it returns.
        def walk(node: TreeNode, total: int) -> None:
            path.append(node.val)
            total += node.val
            if not node.left and not node.right:
                if total == target:
                    paths.append(list(path))
            for child in (node.left, node.right):
                if child:
                    walk(child, total)
            path.pop()

        if root:
            walk(root, 0)
        return paths
