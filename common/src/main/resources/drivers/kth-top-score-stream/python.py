{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
obj = None
for op, arg in zip(ops, args):
    if op == "TopKStream":
        obj = TopKStream(arg[0], arg[1])
        result.append(None)
    elif op == "record":
        result.append(obj.record(arg[0]))
print(json.dumps(result, separators=(',', ':')))
