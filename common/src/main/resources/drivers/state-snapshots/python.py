{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
snap_arr = None
for op, arg in zip(ops, args):
    if op == "SnapshotArray":
        snap_arr = SnapshotArray(arg[0])
        result.append(None)
    elif op == "set":
        snap_arr.set(arg[0], arg[1])
        result.append(None)
    elif op == "snap":
        result.append(snap_arr.snap())
    elif op == "get":
        result.append(snap_arr.get(arg[0], arg[1]))
print(json.dumps(result, separators=(',', ':')))
