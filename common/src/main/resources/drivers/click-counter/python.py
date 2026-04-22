{USER_CODE}

import json

ops = json.loads(input())
args = json.loads(input())

obj = None
result = []
for op, arg in zip(ops, args):
    if op == "ClickTally":
        obj = ClickTally()
        result.append(None)
    elif op == "record":
        obj.record(arg[0])
        result.append(None)
    elif op == "countSince":
        result.append(obj.countSince(arg[0]))

print(json.dumps(result, separators=(',', ':')))
