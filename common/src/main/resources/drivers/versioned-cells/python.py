{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
cells = None
for op, arg in zip(ops, args):
    if op == "VersionedCells":
        cells = VersionedCells(arg[0])
        result.append(None)
    elif op == "set":
        cells.set(arg[0], arg[1])
        result.append(None)
    elif op == "commit":
        result.append(cells.commit())
    elif op == "readAt":
        result.append(cells.readAt(arg[0], arg[1]))
print(json.dumps(result, separators=(',', ':')))
