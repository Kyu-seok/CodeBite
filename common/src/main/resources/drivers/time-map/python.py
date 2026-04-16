{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "TimeMap":
        obj = TimeMap()
        result.append(None)
    elif op == "set":
        obj.set(arg[0], arg[1], arg[2])
        result.append(None)
    elif op == "get":
        result.append(obj.get(arg[0], arg[1]))

print(json.dumps(result, separators=(',', ':')))
