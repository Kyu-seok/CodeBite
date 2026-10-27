import heapq
from typing import Optional


class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def merge_k_lists(self, queues: list[Optional[ListNode]]) -> Optional[ListNode]:
        # Heap of (value, queue index, node); the index breaks ties so nodes are never compared.
        heap = [(node.val, i, node) for i, node in enumerate(queues) if node]
        heapq.heapify(heap)
        dummy = tail = ListNode()
        while heap:
            _, i, node = heapq.heappop(heap)
            tail.next = node
            tail = node
            if node.next:
                heapq.heappush(heap, (node.next.val, i, node.next))
        return dummy.next
