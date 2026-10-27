class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def combineOvenRotations(self, runA: ListNode | None, runB: ListNode | None) -> ListNode | None:
        dummy = tail = ListNode()
        while runA and runB:
            if runA.val <= runB.val:
                tail.next, runA = runA, runA.next
            else:
                tail.next, runB = runB, runB.next
            tail = tail.next
        tail.next = runA or runB
        return dummy.next
