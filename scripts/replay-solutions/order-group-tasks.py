from collections import deque


class Solution:
    def find_task_order(self, num_tasks: int, prereqs: list[list[int]]) -> list[int]:
        unlocks: list[list[int]] = [[] for _ in range(num_tasks)]
        waiting = [0] * num_tasks
        for task, needed in prereqs:
            unlocks[needed].append(task)
            waiting[task] += 1

        ready = deque(t for t in range(num_tasks) if waiting[t] == 0)
        order: list[int] = []
        while ready:
            task = ready.popleft()
            order.append(task)
            for nxt in unlocks[task]:
                waiting[nxt] -= 1
                if waiting[nxt] == 0:
                    ready.append(nxt)
        return order if len(order) == num_tasks else []
