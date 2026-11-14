from collections import deque


class Solution:
    def findTaskOrder(self, numTasks: int, prereqs: list[list[int]]) -> list[int]:
        unlocks: list[list[int]] = [[] for _ in range(numTasks)]
        waiting = [0] * numTasks
        for task, needed in prereqs:
            unlocks[needed].append(task)
            waiting[task] += 1

        ready = deque(t for t in range(numTasks) if waiting[t] == 0)
        order: list[int] = []
        while ready:
            task = ready.popleft()
            order.append(task)
            for nxt in unlocks[task]:
                waiting[nxt] -= 1
                if waiting[nxt] == 0:
                    ready.append(nxt)
        return order if len(order) == numTasks else []
