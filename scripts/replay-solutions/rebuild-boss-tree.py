class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def assembleBreakdown(self, preorder: list[int], inorder: list[int]) -> TreeNode | None:
        position = {value: index for index, value in enumerate(inorder)}
        next_root = iter(preorder)

        def build(low: int, high: int) -> TreeNode | None:
            if low > high:
                return None
            node = TreeNode(next(next_root))
            middle = position[node.val]
            node.left = build(low, middle - 1)
            node.right = build(middle + 1, high)
            return node

        return build(0, len(inorder) - 1)
