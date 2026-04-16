{USER_CODE}

import json
ops = json.loads(input())
args = json.loads(input())
result = []
m = None
for op, arg in zip(ops, args):
    if op == "SimpleHashMap":
        m = SimpleHashMap()
        result.append(None)
    elif op == "put":
        m.put(arg[0], arg[1])
        result.append(None)
    elif op == "get":
        result.append(m.get(arg[0]))
    elif op == "remove":
        m.remove(arg[0])
        result.append(None)
print(json.dumps(result, separators=(',', ':')))
