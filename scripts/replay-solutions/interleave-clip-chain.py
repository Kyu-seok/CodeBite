from typing import Optional


class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def interleaveClips(self, head: Optional[ListNode]) -> None:
        # Split at the middle, reverse the second half, then weave the halves together.
        if head is None or head.next is None:
            return
        slow = fast = head
        while fast.next and fast.next.next:
            slow = slow.next
            fast = fast.next.next
        prev, curr = None, slow.next
        slow.next = None
        while curr:
            nxt = curr.next
            curr.next = prev
            prev, curr = curr, nxt
        first, second = head, prev
        while second:
            next1, next2 = first.next, second.next
            first.next = second
            second.next = next1
            first, second = next1, next2
