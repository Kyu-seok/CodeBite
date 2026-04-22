{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "TimestampedStore":
        obj = TimestampedStore()
        result.append(None)
    elif op == "write":
        obj.write(arg[0], arg[1], arg[2])
        result.append(None)
    elif op == "readAt":
        result.append(obj.readAt(arg[0], arg[1]))

print(json.dumps(result, separators=(',', ':')))
