{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "RecentCache":
        obj = RecentCache(arg[0])
        result.append(None)
    elif op == "put":
        obj.put(arg[0], arg[1])
        result.append(None)
    elif op == "get":
        result.append(obj.get(arg[0]))

print(json.dumps(result, separators=(',', ':')))
