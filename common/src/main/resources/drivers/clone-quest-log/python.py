{USER_CODE}

import json

data = json.loads(input())

if not data:
    print("[]")
else:
    nodes = [Node(p[0]) for p in data]
    for i in range(len(nodes) - 1):
        nodes[i].next = nodes[i + 1]
    for i, p in enumerate(data):
        if p[1] is not None:
            nodes[i].related = nodes[p[1]]

    result = Solution().cloneQuestLog(nodes[0])

    index_map = {}
    curr = result
    idx = 0
    while curr:
        index_map[id(curr)] = idx
        idx += 1
        curr = curr.next

    output = []
    curr = result
    while curr:
        related_idx = index_map[id(curr.related)] if curr.related else None
        output.append([curr.val, related_idx])
        curr = curr.next

    print(json.dumps(output, separators=(',', ':')))
