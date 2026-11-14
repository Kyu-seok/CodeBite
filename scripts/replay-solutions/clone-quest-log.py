from typing import Optional


class Node:
    def __init__(self, val=0, next=None, related=None):
        self.val = val
        self.next = next
        self.related = related


class Solution:
    def cloneQuestLog(self, head: Optional[Node]) -> Optional[Node]:
        copies: dict[Node, Node] = {}
        node = head
        while node:
            copies[node] = Node(node.val)
            node = node.next
        for original, copy in copies.items():
            copy.next = copies.get(original.next)
            copy.related = copies.get(original.related)
        return copies.get(head)
