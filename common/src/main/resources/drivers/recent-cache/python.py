{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "RecentRegistry":
        obj = RecentRegistry(arg[0])
        result.append(None)
    elif op == "store":
        obj.store(arg[0], arg[1])
        result.append(None)
    elif op == "lookup":
        result.append(obj.lookup(arg[0]))

print(json.dumps(result, separators=(',', ':')))
