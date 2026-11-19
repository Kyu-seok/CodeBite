from collections import deque


class Solution:
    def canFinishAllTasks(self, numTasks: int, prereqs: list[list[int]]) -> bool:
        unlocks: list[list[int]] = [[] for _ in range(numTasks)]
        waiting = [0] * numTasks
        for task, before in prereqs:
            unlocks[before].append(task)
            waiting[task] += 1
        ready = deque(task for task in range(numTasks) if waiting[task] == 0)
        done = 0
        while ready:
            task = ready.popleft()
            done += 1
            for unlocked in unlocks[task]:
                waiting[unlocked] -= 1
                if waiting[unlocked] == 0:
                    ready.append(unlocked)
        return done == numTasks
