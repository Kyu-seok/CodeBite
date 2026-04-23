{USER_CODE}

import json
from collections import deque

def _build_graph(adj_list):
    if not adj_list:
        return None
    n = len(adj_list)
    nodes = [None] + [Node(i + 1) for i in range(n)]
    for i, neighbors in enumerate(adj_list):
        for nbr in neighbors:
            nodes[i + 1].neighbors.append(nodes[nbr])
    return nodes[1]

def _graph_to_adj_list(node):
    if not node:
        return []
    visited = {}
    queue = deque([node])
    visited[node.val] = node
    while queue:
        curr = queue.popleft()
        for nbr in curr.neighbors:
            if nbr.val not in visited:
                visited[nbr.val] = nbr
                queue.append(nbr)
    result = []
    for val in sorted(visited.keys()):
        result.append([nbr.val for nbr in visited[val].neighbors])
    return result

adj_list = json.loads(input())
node = _build_graph(adj_list)
cloned = Solution().snapshotMeshLayout(node)
print(json.dumps(_graph_to_adj_list(cloned), separators=(',', ':')))
