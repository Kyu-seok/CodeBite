from collections import deque


class Solution:
    def find_order(self, num_courses: int, prereqs: list[list[int]]) -> list[int]:
        unlocks: list[list[int]] = [[] for _ in range(num_courses)]
        waiting = [0] * num_courses
        for course, needed in prereqs:
            unlocks[needed].append(course)
            waiting[course] += 1

        ready = deque(c for c in range(num_courses) if waiting[c] == 0)
        order: list[int] = []
        while ready:
            course = ready.popleft()
            order.append(course)
            for nxt in unlocks[course]:
                waiting[nxt] -= 1
                if waiting[nxt] == 0:
                    ready.append(nxt)
        return order if len(order) == num_courses else []
