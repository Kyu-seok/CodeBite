{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
snap_arr = None
for op, arg in zip(ops, args):
    if op == "VersionedCells":
        snap_arr = VersionedCells(arg[0])
        result.append(None)
    elif op == "set":
        snap_arr.set(arg[0], arg[1])
        result.append(None)
    elif op == "commit":
        result.append(snap_arr.commit())
    elif op == "readAt":
        result.append(snap_arr.readAt(arg[0], arg[1]))
print(json.dumps(result, separators=(',', ':')))
