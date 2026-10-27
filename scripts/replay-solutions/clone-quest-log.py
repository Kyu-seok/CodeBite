from typing import Optional


class Node:
    def __init__(self, val=0, next=None, random=None):
        self.val = val
        self.next = next
        self.random = random


class Solution:
    def copy_random_list(self, head: Optional[Node]) -> Optional[Node]:
        copies: dict[Node, Node] = {}
        node = head
        while node:
            copies[node] = Node(node.val)
            node = node.next
        for original, copy in copies.items():
            copy.next = copies.get(original.next)
            copy.random = copies.get(original.random)
        return copies.get(head)
