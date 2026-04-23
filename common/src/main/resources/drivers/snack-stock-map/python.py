{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
m = None
for op, arg in zip(ops, args):
    if op == "ChainedMap":
        m = ChainedMap()
        result.append(None)
    elif op == "set":
        m.set(arg[0], arg[1])
        result.append(None)
    elif op == "lookup":
        result.append(m.lookup(arg[0]))
    elif op == "erase":
        m.erase(arg[0])
        result.append(None)
print(json.dumps(result, separators=(',', ':')))
