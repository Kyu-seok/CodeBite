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
            nodes[i].random = nodes[p[1]]

    result = Solution().copy_random_list(nodes[0])

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
        rand_idx = index_map[id(curr.random)] if curr.random else None
        output.append([curr.val, rand_idx])
        curr = curr.next

    print(json.dumps(output, separators=(',', ':')))
