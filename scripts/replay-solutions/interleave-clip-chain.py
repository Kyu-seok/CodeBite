from typing import Optional


class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def reorder_list(self, head: Optional[ListNode]) -> None:
        # Split at the middle, reverse the second half, then weave the halves together.
        if head is None or head.next is None:
            return
        slow = fast = head
        while fast.next and fast.next.next:
            slow = slow.next
            fast = fast.next.next
        second, slow.next = slow.next, None
        reversed_head = None
        while second:
            following = second.next
            second.next = reversed_head
            reversed_head = second
            second = following
        first, second = head, reversed_head
        while second:
            first_next, second_next = first.next, second.next
            first.next = second
            second.next = first_next
            first, second = first_next, second_next
