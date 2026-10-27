class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def widestCatalogSpan(self, root: TreeNode | None) -> int:
        best = 0

        def depth(node: TreeNode | None) -> int:
            nonlocal best
            if node is None:
                return 0
            left, right = depth(node.left), depth(node.right)
            best = max(best, left + right)
            return 1 + max(left, right)

        depth(root)
        return best
