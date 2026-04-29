{USER_CODE}

import json
from collections import deque


def _has_cycle(n, prereqs):
    adj = [[] for _ in range(n)]
    indeg = [0] * n
    for a, b in prereqs:
        adj[b].append(a)
        indeg[a] += 1
    q = deque(i for i in range(n) if indeg[i] == 0)
    processed = 0
    while q:
        u = q.popleft()
        processed += 1
        for v in adj[u]:
            indeg[v] -= 1
            if indeg[v] == 0:
                q.append(v)
    return processed != n


def _is_valid(n, prereqs, result):
    if result is None:
        return False
    if len(result) == 0:
        return _has_cycle(n, prereqs)
    if len(result) != n:
        return False
    seen = [False] * n
    pos = [0] * n
    for i, v in enumerate(result):
        if v < 0 or v >= n or seen[v]:
            return False
        seen[v] = True
        pos[v] = i
    for a, b in prereqs:
        if pos[b] >= pos[a]:
            return False
    return True


num_courses = int(input())
prerequisites = json.loads(input())
result = Solution().find_order(num_courses, prerequisites)
print("VALID" if _is_valid(num_courses, prerequisites, result) else "INVALID")
