from collections import deque


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Codec:
    def serialize(self, root: TreeNode | None) -> str:
        parts: list[str] = []
        queue = deque([root])
        while queue:
            node = queue.popleft()
            if node is None:
                parts.append("#")
            else:
                parts.append(str(node.val))
                queue.append(node.left)
                queue.append(node.right)
        return ",".join(parts)

    def deserialize(self, data: str) -> TreeNode | None:
        tokens = data.split(",")
        if tokens[0] == "#":
            return None
        root = TreeNode(int(tokens[0]))
        queue = deque([root])
        i = 1
        while queue:
            node = queue.popleft()
            if tokens[i] != "#":
                node.left = TreeNode(int(tokens[i]))
                queue.append(node.left)
            if tokens[i + 1] != "#":
                node.right = TreeNode(int(tokens[i + 1]))
                queue.append(node.right)
            i += 2
        return root
